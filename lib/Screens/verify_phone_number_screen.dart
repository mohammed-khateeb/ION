import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ion_application/Controller/auth_controller.dart';
import 'package:ion_application/Models/Responses/httpresponse.dart';
import 'package:ion_application/Utils/navigtor_utils.dart';
import 'package:ion_application/Utils/user_utils.dart';
import 'package:ion_application/Widgets/custom_app_bar.dart';
import 'package:ion_application/Widgets/custom_inkwell.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:show_up_animation/show_up_animation.dart';
import '../Localization/current_language.dart';
import '../Localization/language_constants.dart';
import '../Models/Api/user.dart' as userApp;

import '../Push_notification/push_notification_serveice.dart';
import '../Utils/color_utils.dart';
import '../Utils/device_utils.dart';
import '../Utils/main_utils.dart';
import '../Widgets/custom_animation_up.dart';
import '../Widgets/custom_button.dart';
import '../Widgets/waiting_widget.dart';
import '../main.dart';

class VerifyPhoneNumberScreen extends StatefulWidget {
  static const id = 'VerifyPhoneNumberScreen';
  final userApp.User user;

  const VerifyPhoneNumberScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<VerifyPhoneNumberScreen> createState() =>
      _VerifyPhoneNumberScreenState();
}

class _VerifyPhoneNumberScreenState extends State<VerifyPhoneNumberScreen>
    with WidgetsBindingObserver {
  userApp.User user = userApp.User();
  String verificationId = '';
  bool isCodeSent = false;
  int timerSeconds = 60;

  Timer? _timer;

  void startTimer() {
    _timer?.cancel(); // Cancel any existing timer

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (timerSeconds > 0) {
          timerSeconds--;
        } else {
          _timer?.cancel(); // Stop the timer
        }
      });
    });
  }
  @override
  void initState() {
    verifyPhoneNumber(widget.user.mobileNumber!);
    super.initState();
  }


  Future onCompleteVerify(PhoneAuthCredential credential) async {
    MainUtils.hideWaitingProgressDialog();
    MainUtils.showWaitingProgressDialog();
    try{
      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      String? token = await userCredential.user!.getIdToken();

      bool tokenIsValid = await checkToken(token!);


      if(tokenIsValid){
        await UserUtils.updateCurrentUserToken(token).then((value) {
          getProfile().then((value) async {
            print("--------${tokenIsValid}");
            print(token);
            MainUtils.hideWaitingProgressDialog();
            if(context.read<AuthController>().user==null) {
              await UserUtils.updateCurrentUserToken(token,directly: false);
              signUpPhoneNumber(token);
            }
            else{
              signInPhoneNumber();
            }
            log(
              VerifyPhoneNumberScreen.id,
              name: 'OTP was verified manually!',
            );
            log(
              VerifyPhoneNumberScreen.id,
              name: 'Login Success UID: ${userCredential.user?.uid}',
            );

          });

        });
        //registerNotificationToken();
      }
      else{
        MainUtils.hideWaitingProgressDialog();
        await UserUtils.updateCurrentUserToken(token,directly: false);
        signUpPhoneNumber(token);
      }

    }catch(e){
      MainUtils.hideWaitingProgressDialog();
      if(e.toString().contains("invalid-verification-code")){
        MainUtils.showErrorAlertDialog(context, getTranslated(context, "invalid_pin")!);
      }
      else{
        MainUtils.showErrorAlertDialog(context, e.toString());

      }
    }
  }

  Future verifyPhoneNumber(String phoneNumber) async {
    setState(() {
      isCodeSent = false;
      timerSeconds = 80;
    });

    startTimer();
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        onCompleteVerify(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        MainUtils.hideWaitingProgressDialog();
        Navigator.pop(context);
        if (e.message != null &&
            e.message!
                .toLowerCase()
                .contains("create the phone auth credential is invalid")) {
          MainUtils.showErrorAlertDialog(context,
              getTranslated(context, "theEnteredCodeIsIncorrectTryAgain")!);
        } else if (e.message != null &&
            e.message!.toLowerCase().contains(
                "the format of the phone number provided is incorrect")) {
          MainUtils.showErrorAlertDialog(context,getTranslated(
              context, "theFormatOfThePhoneNumberProvidedIsIncorrect")!);
        } else {
          MainUtils.showErrorAlertDialog(context,e.message ??
              getTranslated(context, "somethingWentWrong")!);
        }
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          this.verificationId = verificationId;
          isCodeSent = true;
        });
      },

      codeAutoRetrievalTimeout: (String verificationId) {
      },
      timeout: const Duration(seconds: 60),
    );
  }


  Future<void> resendCode(String phoneNumber) async {
    await verifyPhoneNumber(phoneNumber);

  }

  Future<bool> checkToken(String token)async{
    bool tokenIsValid = await context.read<AuthController>().checkToken(token);
    return tokenIsValid;
  }

  Future updateDeviceId(String token,String deviceId)async{
    print("deviceId = $deviceId");
    HttpResponse response = await context.read<AuthController>().updateDeviceId(token,deviceId);
    print("response update device = ${response.message}");
  }

  Future registerNotificationToken()async{
    HttpResponse response = await context.read<AuthController>().updateFcmToken(PushNotificationServices.fcmToken!);
    print("registerNotificationToken = ${response.responseCode}");
  }

  Future changeLanguage(String language)async{
    HttpResponse response = await context.read<AuthController>().changeLanguage(language);
    print("response change language");
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: CustomAppBar(
          action: Center(
            child: CustomInkwell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Text(
                getTranslated(context, "change_number")!,
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.02,
                    color: kPrimaryColor),
              ),
            ),
          ),
        ),
        body:isCodeSent? Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: size.height * 0.03,
              ),
              Center(
                child: CustomAnimationUp(
                  millisecond: 400,
                  child: Text(
                    getTranslated(context, "enter_authentication_code")!,
                    style:
                    TextStyle(fontSize: size.height * 0.028, fontFamily:  currentLanguageIsEnglish ? "bold": "Arabic_Bold"),
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.04,
              ),
              CustomAnimationUp(
                millisecond: 500,
                child: Padding(
                    padding: EdgeInsetsDirectional.only(end: size.width * 0.05),
                    child: Column(
                      children: [
                        Text(
                          getTranslated(context, "enter_the_digit_that_we_have_sent_via_the_phone_number")!,
                          style: TextStyle(
                              fontSize: size.height * 0.018,
                              fontFamily:  currentLanguageIsEnglish ? "Medium": "Arabic_Font",
                              color: Colors.grey[800]),
                        ),
                        SizedBox(height: size.height*0.005,),
                        Directionality(
                          textDirection: TextDirection.ltr,
                          child: Text(
                            MainUtils.validPhoneNumberWithDashes(
                                widget.user.mobileNumber!),
                            style: TextStyle(
                                fontSize: size.height * 0.018,
                                fontFamily:  currentLanguageIsEnglish ? "Bold": "Arabic_Bold",
                                color: Colors.grey[800]),
                          ),
                        ),
                      ],
                    )),
              ),
              SizedBox(
                height: size.height * 0.06,
              ),
              Center(
                child: CustomAnimationUp(
                  millisecond: 600,
                  child: Directionality(
                    textDirection: TextDirection.ltr,
                    child: PinCodeTextField(
                      appContext: context,
                      useExternalAutoFillGroup: true,
                      enablePinAutofill: true,
                      pastedTextStyle: TextStyle(
                        color: Colors.green.shade600,
                        fontWeight: FontWeight.bold,
                      ),
                      length: 6,
                      obscureText: false,
                      obscuringCharacter: '*',
                      blinkWhenObscuring: true,
                      animationType: AnimationType.fade,
                      pinTheme: PinTheme(
                          shape: PinCodeFieldShape.circle,
                          activeColor: Colors.grey[300],
                          activeFillColor: Colors.white,
                          inactiveColor: Colors.grey[300],
                          selectedColor: kPrimaryColor,
                          selectedFillColor: Colors.transparent,
                          inactiveFillColor: Colors.transparent,
                          borderWidth: 1,
                          fieldWidth: size.width * 0.125),
                      cursorColor: Colors.black,
                      animationDuration: const Duration(milliseconds: 300),
                      enableActiveFill: true,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {},
                      onCompleted: verifyOTP,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.0,
              ),

              CustomAnimationUp(
                millisecond: 800,
                child: TextButton(
                  onPressed: timerSeconds != 0
                      ? null
                      : () async {
                          log(VerifyPhoneNumberScreen.id, name: 'Resend OTP');
                          await resendCode(widget.user.mobileNumber!);
                        },
                  child: Text(
                    timerSeconds != 0
                        ? '${getTranslated(context, "resendCodeAt")!}${timerSeconds}'
                        : getTranslated(context, "resend_code")!,
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontWeight: FontWeight.normal,
                      fontSize: size.height * 0.018,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ):Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            WaitingWidget(),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            Text(
              getTranslated(context, "sendingOTP")!,
              style: TextStyle(
                  fontSize:
                  MediaQuery.of(context).size.height * 0.022),
            ),
          ],
        ),

      )
    );
  }

  Future<void> verifyOTP(String otp) async {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );

      onCompleteVerify(credential);
  }

  signUpPhoneNumber(String? token) async {
    initUserData(user, token: token);
    NavigatorUtils.navigateToSignupScreen(context, user: user);
  }

  Future getProfile()async{
    await context.read<AuthController>().getProfile();
  }

  signInPhoneNumber() async {
    if (UserUtils.firstUse) {
      NavigatorUtils.navigateToTutorialScreen(context);
    } else {
    NavigatorUtils.navigateToHomeScreen(context);
    }
  }

  initUserData(userApp.User user, {String? token}) {
    this.user.apiToken = token;
    this.user.fcmToken = PushNotificationServices.fcmToken;
  }
}

