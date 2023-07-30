import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ion_application/Controller/auth_controller.dart';
import 'package:ion_application/Localization/language_constants.dart';
import 'package:ion_application/Utils/color_utils.dart';
import 'package:ion_application/Utils/main_utils.dart';
import 'package:ion_application/Utils/navigtor_utils.dart';
import 'package:ion_application/Widgets/custom_inkwell.dart';
import 'package:provider/provider.dart';

import '../Localization/current_language.dart';
import '../Utils/mqtt_handler.dart';
import '../Utils/user_utils.dart';
import '../Widgets/reusable_cached_network_image.dart';

class DrawerComponent extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const DrawerComponent({Key? key, required this.scaffoldKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double topPadding = MediaQuery.of(context).padding.top;
    return Stack(
      children: [
        BackdropFilter(
          filter: ImageFilter.blur(
            sigmaY: 5,
            sigmaX: 5
          ),
          child: const SizedBox.expand(),
        ),
        Drawer(
          elevation: 0.5,
          width: size.width*0.65,
          child: Column(
            children: [
              SizedBox(
                height: size.height * 0.04 + topPadding,
              ),
               Padding(
                 padding: EdgeInsetsDirectional.only(
                   start: size.width*0.05
                 ),
                 child: Row(
                   children: [
                     Stack(
                       children: [
                         Container(
                           height: size.height*0.067,
                           width: size.height*0.067,
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
                         Positioned.fill(
                           child: Align(
                             alignment: AlignmentDirectional.bottomEnd,
                             child: Container(
                               height: size.height*0.02,
                               width: size.height*0.02,
                               decoration: BoxDecoration(
                                   color: Colors.green,
                                   shape: BoxShape.circle,
                                   border: Border.all(color: Colors.white,width: 2)
                               ),
                             ),
                           ),
                         ),
                       ],
                     ),
                     SizedBox(width: size.width*0.025,),
                     Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Text(
                           getTranslated(context, "balance")!,
                           style: TextStyle(
                             fontSize: size.height*0.015
                           ),
                         ),
                         Text(
                           "${context.watch<AuthController>().user?.balance??0} ${getTranslated(context, "jod")!}",
                           style: TextStyle(
                               fontSize: size.height*0.015,
                             fontFamily:  currentLanguageIsEnglish ? "bold": "Arabic_Bold"
                           ),
                         )
                       ],
                     )
                   ],
                 ),
               ),
              SizedBox(height: size.height*0.07,),
              customListCard(
                context: context,
                size: size,
                title: "profile",
                iconName: "user_check",
                onTab: (){
                  scaffoldKey.currentState!.closeDrawer();
                  NavigatorUtils.navigateToSignupScreen(context);
                }
              ),
              // customListCard(
              //     context: context,
              //     size: size,
              //     title: "payment",
              //     iconName: "coins",
              //     onTab: (){}
              // ),
              customListCard(
                  context: context,
                  size: size,
                  title: "my_session",
                  iconName: "my_session",
                  onTab: (){
                    UserUtils.checkTokenValidation(
                      afterCheck: (){
                        scaffoldKey.currentState!.closeDrawer();
                        NavigatorUtils.navigateToSessionScreen(context);
                      }
                    );
                  }
              ),
              customListCard(
                  context: context,
                  size: size,
                  title: "tutorial",
                  iconName: "faq",
                  onTab: (){
                    scaffoldKey.currentState!.closeDrawer();
                    NavigatorUtils.navigateToTutorialScreen(context,fromHome: true);
                  }
              ),

              customListCard(
                  context: context,
                  size: size,
                  title: "about_ion",
                  iconName: "about_ion",
                  onTab: (){
                    scaffoldKey.currentState!.closeDrawer();

                    NavigatorUtils.navigateToStaticPageScreen(context, "https://api.evse.cloud/api/v3/app/about");
                  }
              ),
              SizedBox(height: size.height*0.05,),
              // Row(
              //   children: [
              //     Padding(
              //       padding: EdgeInsets.symmetric(
              //           horizontal: size.width*0.05
              //       ),
              //       child: Container(
              //         decoration: BoxDecoration(
              //           color: kPrimaryColor,
              //           borderRadius: BorderRadius.circular(size.height*0.01)
              //         ),
              //         padding: EdgeInsets.symmetric(
              //           vertical: size.height*0.015,
              //           horizontal: size.width*0.05
              //         ),
              //         child: Column(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             Text(
              //               getTranslated(context, "premium_membership")!,
              //               style: TextStyle(
              //                 fontSize: size.height*0.022,
              //                 fontFamily:  currentLanguageIsEnglish ? "bold": "Arabic_Bold",
              //                 color: Colors.white
              //               ),
              //             ),
              //             SizedBox(height: size.height*0.005,),
              //             Text(
              //               getTranslated(context, "upgrade_for_more_features")!,
              //               style: TextStyle(
              //                   fontSize: size.height*0.015,
              //                   color: Colors.white
              //               ),
              //             )
              //           ],
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              const Spacer(),
              Padding(
                padding: EdgeInsetsDirectional.only(
                  start: size.width*0.05
                ),
                child: CustomInkwell(
                  onTap: (){
                    NavigatorUtils.navigateToStaticPageScreen(context, "https://api.evse.cloud/api/v3/app/tc");
                  },
                  child: Row(
                    children: [
                      Image.asset(
                        "assets/icons/terms_conditions.png",
                        height: size.height*0.022,
                      ),
                      SizedBox(
                          width: size.width*0.03
                      ),
                      Text(
                        getTranslated(context, "terms_conditions")!,
                        style: TextStyle(
                          fontSize: size.height*0.017,
                            color: Colors.black

                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: size.height*0.023,),
              Padding(
                padding: EdgeInsetsDirectional.only(
                    start: size.width*0.05
                ),
                child: CustomInkwell(
                  onTap: (){
                    NavigatorUtils.navigateToStaticPageScreen(context, "https://api.evse.cloud/api/v3/app/privacy");
                  },
                  child: Row(
                    children: [
                      Image.asset(
                        "assets/icons/privacy_policy.png",
                        height: size.height*0.022,
                      ),
                      SizedBox(
                        width: size.width*0.03
                      ),
                      Text(
                        getTranslated(context, "privacy_policy")!,
                        style: TextStyle(
                            fontSize: size.height*0.017,
                          color: Colors.black
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: size.height*0.03,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: size.width*0.035
                ),
                child: CustomInkwell(
                  onTap: ()async{
                    MainUtils.showWaitingProgressDialog();
                    await context.read<AuthController>().signOut();
                    context.read<MqttHandler>().disconnectMqtt();

                    MainUtils.hideWaitingProgressDialog();
                    NavigatorUtils.navigateToSplashScreen(context);
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.file_upload_outlined,
                        size: size.height*0.03,
                      ),
                      SizedBox(width: size.width*0.04,),
                      Text(
                        getTranslated(context, "logout")!,
                        style: TextStyle(
                            fontSize: size.height*0.022,
                            fontFamily:  currentLanguageIsEnglish ? "bold": "Arabic_Bold",
                        ),
                      ),
                      const Spacer(),
                      // Container(
                      //   width: 1,
                      //   height: size.height*0.025,
                      //   color: Colors.black,
                      // ),
                      // SizedBox(width: size.width*0.03,),
                      // Icon(
                      //   Icons.settings_outlined,
                      //   size: size.height*0.03,
                      //   color: Colors.grey[800],
                      // ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: size.height*0.03,),
            ],
          ),
        ),
      ],
    );
  }

  customListCard(
      {required BuildContext context,
        required Size size,
        required String title,
        required String iconName,
        required Function onTab}){
    return ListTile(
      leading: Padding(
        padding:  EdgeInsets.only(top: size.height*0.003),
        child: Image.asset(
          "assets/icons/$iconName.png",
          height: size.height*0.02,
        ),
      ),
      minLeadingWidth: 0,
      title: Text(
        getTranslated(context, title)!,
        style: TextStyle(
          fontWeight: FontWeight.normal,
            fontSize:currentLanguageIsEnglish ? size.height*0.019:size.height*0.018,
            fontFamily:  currentLanguageIsEnglish ? "bold": "Arabic_Font"
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: size.height*0.02,
        color: Colors.grey[800],
      ),
      onTap: () {
       onTab();
      },
    );
  }
}
