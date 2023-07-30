import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:ion_application/Controller/auth_controller.dart';
import 'package:ion_application/Localization/language_constants.dart';
import 'package:flutter/material.dart';
import 'package:ion_application/Models/Api/current_user.dart';
import 'package:ion_application/Models/Responses/httpresponse.dart';
import 'package:ion_application/Utils/device_utils.dart';
import 'package:ion_application/Utils/main_utils.dart';
import 'package:ion_application/Utils/pick_image_utils.dart';
import 'package:ion_application/Widgets/custom_inkwell.dart';
import 'package:provider/provider.dart';
import 'package:show_up_animation/show_up_animation.dart';
import '../Models/Api/user.dart';
import '../Push_notification/push_notification_serveice.dart';
import '../Utils/navigtor_utils.dart';
import '../Utils/user_utils.dart';
import '../Widgets/custom_animation_up.dart';
import '../Widgets/custom_app_bar.dart';
import '../Widgets/custom_button.dart';
import '../Widgets/custom_text_field.dart';

class SignupScreen extends StatefulWidget {
  final User? user;

  const SignupScreen({Key? key, this.user}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final ImagePicker _picker = ImagePicker();
  PageController pageController = PageController();
  final _formKey = GlobalKey<FormState>();
  bool isDriver = false;
  int currentPage = 0;

  XFile? profilePicture;
  final TextEditingController firstController = TextEditingController();
  final TextEditingController lastController = TextEditingController();
  final TextEditingController emailController = TextEditingController();



  bool showPassword = true;




  setFields(User user) {
    firstController.text = user.firstName??"";
    lastController.text = user.lastName??"";
    emailController.text = user.email??"";
  }

  @override
  void initState() {
    if(widget.user==null&&context.read<AuthController>().user!=null){
      setFields(context.read<AuthController>().user!);
    }
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return  Scaffold(
        appBar: const CustomAppBar(),
        bottomNavigationBar:widget.user==null?null: CustomAnimationUp(
          millisecond: 1000,
          direction: Direction.horizontal,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: size.width*0.05
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: size.height*0.06,),

                CustomButton(
                  label:getTranslated(context, "continue")!,
                  onPressed: ()=>signUp(),
                ),
                SizedBox(height: size.height*0.06,),
              ],
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: size.width*0.05
          ),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: size.height*0.15,),
                  // CustomAnimationUp(
                  //   millisecond: 400,
                  //   child: CustomInkwell(
                  //     onTap: () async {
                  //       profilePicture = await PickImageUtils.pickImage();
                  //       setState(() {
                  //
                  //       });
                  //     },
                  //     child: Container(
                  //       height: size.height*0.135,
                  //       width: size.height*0.135,
                  //       decoration: BoxDecoration(
                  //         color: Colors.grey[350],
                  //         shape: BoxShape.circle,
                  //         image:profilePicture!=null? DecorationImage(
                  //           image: FileImage(
                  //             File(profilePicture!.path)
                  //           ),
                  //           fit: BoxFit.cover
                  //         ):null
                  //       ),
                  //       child: profilePicture==null?Icon(
                  //         Icons.add,
                  //         size: size.height*0.05,
                  //       ):null,
                  //     ),
                  //   )
                  // ),
                  //
                  // SizedBox(height: size.height*0.05,),
                  Container(
                    height: size.height*0.15,
                    width: size.height*0.15,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            spreadRadius: 2,
                            color: Colors.grey.withOpacity(0.7),
                            blurRadius: 10,
                            offset: const Offset(-2,2)
                        )
                      ],
                      border: Border.all(color: Colors.white,width:4),

                    ),
                    child: Image.asset(
                      "assets/images/profile.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: size.height*0.05,),

                  CustomAnimationUp(
                    millisecond: 600,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: size.height*0.012),
                      child: CustomTextField(
                        label: getTranslated(context, "first_name"),
                        controller: firstController,
                        readOnly: widget.user==null,
                        isRequired:widget.user!=null,
                        withValidate: widget.user!=null,
                      ),
                    ),
                  ),

                  CustomAnimationUp(
                    millisecond: 700,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: size.height*0.012),
                      child: CustomTextField(
                        label: getTranslated(context, "last_name"),
                        controller: lastController,
                        readOnly: widget.user==null,
                        isRequired: widget.user!=null,
                        withValidate: widget.user!=null,
                      ),
                    ),
                  ),

                  CustomAnimationUp(
                    millisecond: 800,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: size.height*0.012),
                      child: CustomTextField(
                        label: getTranslated(context, "email"),
                        controller: emailController,
                        readOnly: widget.user==null,
                        isOptional: widget.user!=null,
                        isRequired: false,
                        withValidate: false,
                      ),
                    ),
                  ),
                  SizedBox(height: size.height*0.08,),
                  CustomAnimationUp(
                    millisecond: 900,
                    child: Text(
                      getTranslated(context,"register_msg")!,
                      style: TextStyle(
                          fontSize: size.height*0.015,
                        color: Colors.grey
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


  Future registerNotificationToken()async{
    HttpResponse response = await context.read<AuthController>().updateFcmToken(PushNotificationServices.fcmToken!);
    print("registerNotificationToken = ${response.responseCode}");
  }


  signUp() async {
    if (!_formKey.currentState!.validate()) return;

    User user;
    user = widget.user!;

    user.firstName = firstController.text;
    user.lastName = lastController.text;
    user.email = emailController.text;

    MainUtils.showWaitingProgressDialog();
    String? deviceId = await DeviceUtils.getDeviceId();

    user.deviceId = deviceId;
    HttpResponse response = await context.read<AuthController>().register(
      user: user
    );

    bool checkTokenResponse = await context.read<AuthController>().checkToken(
        user.apiToken!
    );

    if(checkTokenResponse){
      await UserUtils.updateCurrentUserTokenFromFirstToken();
      await registerNotificationToken();
      await changeLanguage(Platform.localeName.split("_").first);
    }



    MainUtils.hideWaitingProgressDialog();

    if(response.isSuccess == true){
      NavigatorUtils.navigateToAfterSignupScreen(context);
    }
    else{
      MainUtils.showErrorAlertDialog(
          context,
        response.message!
      );
    }

  }


  Future changeLanguage(String language)async{
    HttpResponse response = await context.read<AuthController>().changeLanguage(language);
    print("response change language");
  }





}
