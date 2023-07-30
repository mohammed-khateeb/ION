import 'package:flutter/material.dart';
import 'package:ion_application/Localization/language_constants.dart';
import 'package:ion_application/Utils/navigtor_utils.dart';
import 'package:ion_application/Widgets/custom_button.dart';

import '../Localization/current_language.dart';
import '../Utils/user_utils.dart';

class AfterSignupScreen extends StatelessWidget {
  const AfterSignupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: size.height * 0.1,
            ),
            Image.asset(
              "assets/images/logo.png",
              height: size.height * 0.135,
            ),
            Spacer(),
            Text(
              getTranslated(context, "We_re_done")!,
              style: TextStyle(
                  fontSize: size.height * 0.03,
                  fontFamily:
                      currentLanguageIsEnglish ? "bold" : "Arabic_Bold"),
            ),
            SizedBox(
              height: size.height * 0.025,
            ),
            Text(
              getTranslated(context, "keep_charged")!,
              style: TextStyle(
                  fontSize: size.height * 0.018,
                  height: currentLanguageIsEnglish ? null : 1.5,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: size.height * 0.12,
            ),
            CustomButton(
              label: getTranslated(context, "lets_charge")!,
              onPressed: () {
                if (UserUtils.firstUse) {
                  NavigatorUtils.navigateToTutorialScreen(context);
                } else {
                  NavigatorUtils.navigateToHomeScreen(context);
                }
              },
            ),
            SizedBox(
              height: size.height * 0.07,
            ),
          ],
        ),
      ),
    );
  }
}
