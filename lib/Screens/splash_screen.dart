import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ion_application/Controller/auth_controller.dart';
import 'package:ion_application/Controller/versionController.dart';
import 'package:ion_application/Localization/language_constants.dart';
import 'package:ion_application/Models/Responses/httpresponse.dart';
import 'package:ion_application/Utils/version_utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Utils/user_utils.dart';
import '../Dialogs/app_need_update_dialog.dart';
import '../Push_notification/push_notification_serveice.dart';
import '../Utils/device_utils.dart';
import '../Utils/main_utils.dart';
import '../Utils/navigtor_utils.dart';

class SplashScreen extends StatefulWidget {
  final bool changedToken;
  const SplashScreen({Key? key, this.changedToken = false}) : super(key: key);

  @override
  _SplashScreen createState() => _SplashScreen();
}

class _SplashScreen extends State<SplashScreen> {

  String? fcmToken;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    if(widget.changedToken){
      MainUtils.showErrorAlertDialog(context, getTranslated(context, "session_timeout")!);
    }
    getCurrentUserLocation();
    checkVersion();
  }


  Future getCurrentUserLocation() async {
    LocationPermission permission = await getPermission();
    if(permission == LocationPermission.always||permission == LocationPermission.whileInUse) {
      Geolocator.getCurrentPosition().then((value) {
        MainUtils.navKey.currentContext!.read<AuthController>().setUserPosition(value);
      });
    }
  }



  void initFirebaseMessaging() async {

    _messaging.getToken().then((token) {
      fcmToken = token;
      print("/////////////////$token");
      PushNotificationServices.fcmToken = fcmToken;
      checkIfStayLogin();
    });

    _messaging.onTokenRefresh.listen((newToken) {
      PushNotificationServices.fcmToken = newToken;
      registerNotificationToken();
    });

    FirebaseMessaging.onBackgroundMessage(
        PushNotificationServices.firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      PushNotificationServices.showNotification(message.notification!.title!,message.notification!.body!);
      //FlutterAppBadger.updateBadgeCount(1);
    });
  }

  checkVersion() async {
    bool checkVersion = await context.read<VersionController>().checkVersion();
    if(checkVersion){
      initFirebaseMessaging();
    }
    else{
      showAppNeedUpdateDialog(Platform.isAndroid?androidUrl:iosVersion,false, (){});
    }
  }

  Future<bool> checkToken(String token)async{
    bool tokenIsValid = await context.read<AuthController>().checkToken(token);
    print("token = $token");
    print("token is valid : $tokenIsValid");
    return tokenIsValid;
  }


  Future updateDeviceId(String token,String deviceId)async{
    print("deviceId = $deviceId");
    HttpResponse response = await context.read<AuthController>().updateDeviceId(token,deviceId);
    print("response update device = ${response.message}");
  }


  Future changeLanguage(String language)async{
    HttpResponse response = await context.read<AuthController>().changeLanguage(language);
    print("response change language");
  }


  Future registerNotificationToken()async{
    HttpResponse response = await context.read<AuthController>().updateFcmToken(PushNotificationServices.fcmToken!);
    print("registerNotificationToken = ${response.responseCode}");
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                  "assets/images/splash_background.png"
              ),
            fit: BoxFit.cover
          )
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Image.asset(
            "assets/images/logo.png",
            height: size.height * 0.1,
          ),
        ),
      ),
    );
  }

  void checkIfStayLogin() async {
    AuthController authController = context.read<AuthController>();

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString("token");
    if (token != null) {
      bool tokenIsValid = await checkToken(token);
      if(tokenIsValid){
        String? deviceId = await DeviceUtils.getDeviceId();
        if(deviceId!=null) {
          await updateDeviceId(token, deviceId);
        }
        await UserUtils.fetchUserInformationFromSharedToSingletonClass();
        await changeLanguage(Platform.localeName.split("_").first);
        await registerNotificationToken();
        NavigatorUtils.navigateToHomeScreen(MainUtils.navKey.currentContext!);
      }
      else{
        await FirebaseAuth.instance.currentUser?.reload();
        String? refreshToken = await FirebaseAuth.instance.currentUser?.getIdToken();
          print("////new token = $refreshToken");
          String? deviceId = await DeviceUtils.getDeviceId();
          if(deviceId!=null) {
            await updateDeviceId(refreshToken!, deviceId);
          }
          await UserUtils.updateCurrentUserToken(refreshToken!);
          await UserUtils.fetchUserInformationFromSharedToSingletonClass();
          await changeLanguage(Platform.localeName.split("_").first);
          NavigatorUtils.navigateToHomeScreen(MainUtils.navKey.currentContext!);
      }
    } else {
        NavigatorUtils.navigateToWelcomeScreen(MainUtils.navKey.currentContext!);
    }
  }





  void showAppNeedUpdateDialog(String url, bool showRemindMeLaterButton,
      dynamic onClickRemindMeLaterButton) {
    showGeneralDialog(
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 300),
      context: context,
      pageBuilder: (_, __, ___) {
        return const Center();
      },
      transitionBuilder: (context, a1, a2, widget) {
        return Transform.scale(
          scale: a1.value,
          child: Opacity(
            opacity: a1.value,
            child: AppNeedUpdateDialog(
              url: url,
              showRemindMeLaterButton: showRemindMeLaterButton,
              onClickRemindMeLaterButton: onClickRemindMeLaterButton,
            ),
          ),
        );
      },
    );
  }

  Future<LocationPermission> getPermission() async {

    bool services;
    LocationPermission permission;

    //

    services = await Geolocator.isLocationServiceEnabled();
    if (services == false) {
      AwesomeDialog(
          context: context,
          title: 'services',
          body: const Text('Location not enabled'))
          .show();
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }


    return permission;
  }

}
