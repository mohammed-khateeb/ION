import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ion_application/Controller/auth_controller.dart';
import 'package:ion_application/Controller/charger_controller.dart';
import 'package:ion_application/Controller/transactions_controller.dart';
import 'package:ion_application/Controller/versionController.dart';
import 'package:ion_application/Models/Api/current_user.dart';
import 'package:ion_application/Utils/navigtor_utils.dart';
import 'package:ion_application/Utils/version_utils.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Localization/current_language.dart';
import 'Localization/demo_localization.dart';
import 'Localization/language_constants.dart';
import 'Localization/router/custom_router.dart';
import 'Localization/router/route_constants.dart';
import 'Push_notification/push_notification_serveice.dart';
import 'Utils/device_utils.dart';
import 'Utils/main_utils.dart';
import 'Utils/mqtt_handler.dart';
import 'Utils/user_utils.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  // if (Platform.isAndroid) {
  //   await Firebase.initializeApp();
  // }



  await Firebase.initializeApp();

  PackageInfoConst.packageInfo = await PackageInfo.fromPlatform();

  if (Platform.isIOS) {
    FirebaseMessaging.instance.requestPermission(provisional: false);
  }

  runApp(const MyApp());
}



class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state!.setLocale(newLocale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    checkCurrentLanguage();
    PushNotificationServices.initLocalNotification();
    UserUtils.checkFirstTimeUseApp();

    super.initState();

  }



  Future<bool> checkToken(String token)async{
    bool tokenIsValid = await context.read<AuthController>().checkToken(token);
    print("token in main = $token");
    print("token is valid : $tokenIsValid");
    return tokenIsValid;
  }



  @override
  dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();

  }


  Locale? _locale;

  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() {
    getLocale().then((locale) {
      setState(() {
        _locale = locale;
      });
    });
    super.didChangeDependencies();
  }




  @override
  Widget build(BuildContext context) {
    if (_locale == null) {
      return Container();
    } else {
      return MultiProvider(
        providers: [

          ChangeNotifierProvider<AuthController>(
            create: (context) => AuthController(),
          ),
          ChangeNotifierProvider<VersionController>(
            create: (context) => VersionController(),
          ),

          ChangeNotifierProvider<ChargerController>(
            create: (context) => ChargerController(),
          ),

          ChangeNotifierProvider<MqttHandler>(
            create: (context) => MqttHandler(),
          ),
          ChangeNotifierProvider<TransactionsController>(
            create: (context) => TransactionsController(),
          ),


        ],
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus &&
                currentFocus.focusedChild != null) {
              FocusManager.instance.primaryFocus?.unfocus();
            }
          },
          child:  MaterialApp(
            navigatorKey: MainUtils.navKey,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              fontFamily:_locale!.languageCode=="en"? 'Regular':"Arabic_Font",
              appBarTheme: const AppBarTheme(
                systemOverlayStyle: SystemUiOverlayStyle.dark,
              ),
            ),
            title: 'ION',
            locale: _locale,
            supportedLocales: const [
              Locale("en", "US"),
              Locale("ar", "SA"),
            ],
            localizationsDelegates: const [
              DemoLocalization.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            localeResolutionCallback: (locale, supportedLocales) {
              for (var supportedLocale in supportedLocales) {
                if (supportedLocale.languageCode == locale!.languageCode &&
                    supportedLocale.countryCode == locale.countryCode) {
                  return supportedLocale;
                }
              }
              return supportedLocales.first;
            },
            onGenerateRoute: CustomRouter.generatedRoute,
            initialRoute: start,
          )
        ),
      );
    }
  }
}
