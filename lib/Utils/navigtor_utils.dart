
import 'package:flutter/material.dart';
import 'package:ion_application/Screens/after_signup_screen.dart';
import 'package:ion_application/Screens/home_screen.dart';
import 'package:ion_application/Screens/map_screen.dart';
import 'package:ion_application/Screens/scanner_screen.dart';
import 'package:ion_application/Screens/sessions_screen.dart';
import 'package:ion_application/Screens/signup_screen.dart';
import 'package:ion_application/Screens/splash_screen.dart';
import 'package:ion_application/Screens/static_page_screen.dart';
import 'package:ion_application/Screens/tuturials_screen.dart';
import 'package:ion_application/Screens/verify_phone_number_screen.dart';
import 'package:ion_application/Screens/welcome_screen.dart';
import 'package:page_transition/page_transition.dart';
import '../Models/Api/user.dart';
import '../Screens/login_screen.dart';
import 'mqtt_handler.dart';

class NavigatorUtils {


  static void navigateToWelcomeScreen(context) {
    openNewPage(context,const WelcomeScreen(),popPreviousPages: true);
  }

  static void navigateToTutorialScreen(context,{bool fromHome = false}) {
    openNewPage(context, TutorialScreen(fromHome: fromHome,),popPreviousPages: !fromHome);
  }


  static void navigateToSplashScreen(context,{bool changedToken = false}) {
    openNewPage(context, SplashScreen(changedToken: changedToken,),popPreviousPages: true);

  }


  static void navigateToLoginScreen(context) {
    openNewPage(context,const LoginScreen());

  }



  static void navigateToSessionScreen(context) {
    openNewPage(context,const SessionScreen());

  }

  static void navigateToScannerScreen(context) {
    openNewPage(context,const ScannerScreen());

  }


  static void navigateToMapScreen(context) {
    openNewPage(context,const MapScreen());
  }

  static void navigateToHomeScreen(context) {
    openNewPage(context,const HomeScreen(),popPreviousPages: true);

  }
  static void navigateToAfterSignupScreen(context) {
    openNewPage(context,const AfterSignupScreen(),popPreviousPages: true);

  }


  static void navigateToSignupScreen(context,{ User? user}) {
    openNewPage(context, SignupScreen(user: user,));

  }

  static void navigateToVerifyPhoneNumberScreen(context,{User? user}) {
    openNewPage(context, VerifyPhoneNumberScreen(user: user!,));
  }

  static void navigateToStaticPageScreen(context,String link) {
    openNewPage(context, StaticPageScreen(link: link,));
  }


}


Future<dynamic> openNewPage(BuildContext context, Widget widget,
    {bool popPreviousPages = false}) {

  return  Future<dynamic>.delayed(Duration.zero,(){
    if (!popPreviousPages) {
      return Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.rightToLeft,
          child: widget,
          isIos: true,
          duration: const Duration(milliseconds: 400),
        ),

      );
    } else {
      return Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => widget,
              settings: RouteSettings(
                arguments: widget,
              )),
              (Route<dynamic> route) => false);
    }
  });

}


