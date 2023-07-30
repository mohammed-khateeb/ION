import 'dart:math';

import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Localization/language_constants.dart';
import '../Widgets/custom_button.dart';
import '../Widgets/custom_progress_dialog.dart';
import 'color_utils.dart';

class MainUtils {
  static final navKey = GlobalKey<NavigatorState>();

  static showCustomDialog(Widget dialogWidget,
      {bool barrierDismissible = true}) {
    showDialog(
      barrierDismissible: barrierDismissible,
      context: navKey.currentState!.context,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (context) => dialogWidget,
    );
  }

  static void navigateToMap(double lat, double lng) async {
    var uri = Uri.parse("google.navigation:q=$lat,$lng&mode=d");
    if (await canLaunch(uri.toString())) {
      await launch(uri.toString());
    } else {
      throw 'Could not launch ${uri.toString()}';
    }
  }

  static String validPhoneNumber(String phoneNumber){
    String? validPhone;
    if(phoneNumber.contains("00962")) {
      validPhone = phoneNumber.replaceAll("00962", "+962");
    }
    else if(!phoneNumber.contains("00962")
        &&!phoneNumber.contains("+962")&&phoneNumber.contains("07")){
      validPhone = phoneNumber.replaceFirst("07", "+9627");
    }
    else if(phoneNumber[0]=="7"){
      validPhone = phoneNumber.replaceFirst("7", "+9627");
    }
    else if(phoneNumber[0]=="0"&&phoneNumber[1]=="7"){
      validPhone = phoneNumber.replaceFirst("07", "+9627");
    }
    else{
      validPhone = phoneNumber;
    }
    if(validPhone.contains("+96207")){
      validPhone = validPhone.replaceFirst("+96207", "+9627");
    }

    return validPhone;
  }


  static String validPhoneNumberWithDashes(String validPhoneNumber){
    String subOne = validPhoneNumber.substring(0,4);
    String subTwo = validPhoneNumber.substring(4,6);
    String subThree = validPhoneNumber.substring(6,9);
    String subFour = validPhoneNumber.substring(9,13);

    return "$subOne $subTwo-$subThree-$subFour";
  }

  static makeCall(String phoneNumber) async {
    if (!await launchUrl(Uri.parse("tel:$phoneNumber"))) {
      throw 'Could not call $phoneNumber';
    }
  }

  static sendEmail(String email) async {
    if (!await launchUrl(Uri.parse("mailto:$email"))) {
      throw 'Could not mailto $email';
    }
  }

  static openBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Cant launch';
    }
  }

  static final CustomProgressDialog _progressDialog =
      CustomProgressDialog(context: navKey.currentState!.overlay!.context);

  static final CustomProgressDialog _progressDialogForRegister =
      CustomProgressDialog(
          context: navKey.currentState!.overlay!.context, forRegister: true);

  static showWaitingProgressDialog({bool forRegister = false}) {
    forRegister
        ? _progressDialogForRegister.show(
            progressBgColor: Colors.white,
            msgFontSize: 20,
            msg: getTranslated(
                navKey.currentState!.overlay!.context, 'please_wait')!,
            max: double.maxFinite.round(),
            progressValueColor: kPrimaryColor,
            borderRadius: 10.0,
            backgroundColor: Colors.white,
            elevation: 10,
          )
        : _progressDialog.show(
            progressBgColor: Colors.white,
            msgFontSize: 20,
            msg: getTranslated(
                navKey.currentState!.overlay!.context, 'please_wait')!,
            max: double.maxFinite.round(),
            progressValueColor: kPrimaryColor,
            borderRadius: 10.0,
            backgroundColor: Colors.white,
            elevation: 10,
          );
  }

  static hideWaitingProgressDialog() {
    _progressDialog.close();
    _progressDialogForRegister.close();
  }



  static showErrorAlertDialog(BuildContext context,String msg) {

    Size size = MediaQuery.of(navKey.currentState!.context).size;
    showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(
          message:
          msg,
          textStyle: TextStyle(
            fontSize: size.height*0.02,
            color: Colors.white
          ),
          maxLines: 3,
        ),
        displayDuration: const Duration(milliseconds: 1500)
    );

  }

  static showSuccessAlertDialog(BuildContext context,String msg) {
    Size size = MediaQuery.of(navKey.currentState!.context).size;
    showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.success(
          backgroundColor: kPrimaryColor,
          icon:  Icon(Icons.check_circle_outline, color: Colors.blue[700]!, size: 120),
          message:
          msg,
          textStyle: TextStyle(
              fontSize: size.height*0.02,
              color: Colors.white
          ),
          maxLines: 3,
        ),
        displayDuration: const Duration(milliseconds: 1500)
    );
}

String getStringFromEnum(Object value) => value.toString().split('.').last;

T enumValueFromString<T>(String key, List<T> values) =>
    values.firstWhere((v) => key == getStringFromEnum(v!));

void showSnackBar(
    BuildContext context, String title, String desc, String type) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: type == "warning" ? Colors.amber : Colors.redAccent,
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          desc,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
        )
      ],
    ),
    action: SnackBarAction(
      label: getTranslated(context, 'ok')!,
      onPressed: () {
        // Some code to undo the change.
      },
      textColor: Colors.white,
      disabledTextColor: Colors.grey,
    ),
  ));
}
}
