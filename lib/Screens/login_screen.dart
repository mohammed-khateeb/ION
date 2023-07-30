import 'package:ion_application/Controller/auth_controller.dart';
import 'package:ion_application/Localization/language_constants.dart';
import 'package:ion_application/Utils/main_utils.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:show_up_animation/show_up_animation.dart';
import '../Localization/current_language.dart';
import '../Models/Api/user.dart';
import '../Utils/color_utils.dart';
import '../Utils/navigtor_utils.dart';
import '../Widgets/custom_animation_up.dart';
import '../Widgets/custom_app_bar.dart';
import '../Widgets/custom_button.dart';
import '../Widgets/custom_inkwell.dart';
import '../Widgets/custom_text_field.dart';
import '../main.dart';


class LoginScreen extends StatefulWidget {
  static const String id = '/login_screen';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _formKey = GlobalKey<FormState>();

  final TextEditingController mobileNumberController = TextEditingController();



  final User user = User();

  bool showPassword = true;

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: const CustomAppBar(allowBack: false,),
        bottomNavigationBar: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomAnimationUp(
              millisecond: 700,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: size.width*0.05
                ),
                child: CustomInkwell(
                  onTap: (){
                    NavigatorUtils.navigateToStaticPageScreen(context, "https://api.evse.cloud/api/v3/app/tc");
                  },
                  child: RichText(
                    textAlign: TextAlign.start,
                    text: TextSpan(
                      text: getTranslated(context,"terms_condition_statement")!,
                      style:  TextStyle(
                        height: currentLanguageIsEnglish?null:1.5,
                          fontSize: size.height*0.015,
                          fontFamily:  currentLanguageIsEnglish ? "bold": "Arabic_Bold",
                          color: Colors.grey[800]
                      ),
                      children:  <TextSpan>[
                        TextSpan(text: getTranslated(context,"terms_and_conditions")!, style: TextStyle(fontFamily: currentLanguageIsEnglish?"regular":"Arabic_Font",color: kPrimaryColor)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            CustomAnimationUp(
              millisecond: 800,
              direction: Direction.horizontal,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: size.width*0.05
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: size.height*0.02,),
                    CustomButton(
                      label: getTranslated(context, "next")!,
                      onPressed: ()=>login(),
                    ),
                    SizedBox(height: size.height*0.06,),
                  ],
                ),
              ),
            ),
          ],
        ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: size.width*0.05
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: size.height*0.03,),

                CustomAnimationUp(
                  millisecond: 400,
                  child: Padding(
                    padding: EdgeInsetsDirectional.only(
                      end: size.width*0.1
                    ),
                    child: Text(
                      getTranslated(context,"enter_you_phone_number_to_get_started")!,
                      style: TextStyle(
                        fontSize: size.height*0.028,
                        fontFamily:  currentLanguageIsEnglish ? "bold": "Arabic_Bold"
                      ),
                    ),
                  ),
                ),

                SizedBox(height: size.height*0.1,),
                CustomAnimationUp(
                  millisecond: 500,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: size.height*0.012),
                    child: CustomTextField(
                      controller: TextEditingController(text: getTranslated(context, "jordan")),
                      readOnly: true,
                    ),
                  ),
                ),
                CustomAnimationUp(
                  millisecond: 600,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: size.height*0.012),
                    child: Directionality(
                      textDirection: TextDirection.ltr,
                      child: Row(
                        children: [
                          SizedBox(
                            width: size.width*0.15,
                            child: CustomTextField(
                              controller: TextEditingController(text: "+962"),
                              readOnly: true,
                            ),
                          ),
                          SizedBox(width: size.width*0.05,),
                          Expanded(
                            child: CustomTextField(
                              hintText: getTranslated(context, "example_7xx"),
                              controller: mobileNumberController,
                              maxLength: 10,
                              digitOnly: true,
                              isRequired: false,
                              withValidate: true,
                              onComplete: (){
                                login();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),



              ],
            ),
          ),
        ),
      )
    );
  }

  login() async {

    if(!_formKey.currentState!.validate()){
      return;
    }
    user.mobileNumber = MainUtils.validPhoneNumber(mobileNumberController.text);
      NavigatorUtils.navigateToVerifyPhoneNumberScreen(
        context,user: user
      );
  }


}
