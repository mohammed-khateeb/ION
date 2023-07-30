import 'package:flutter/material.dart';
import 'package:ion_application/Components/Home_Components/pin_code_with_last_session.dart';
import 'package:ion_application/Utils/navigtor_utils.dart';
import 'package:ion_application/Widgets/custom_inkwell.dart';

import '../../Localization/current_language.dart';
import '../../Localization/language_constants.dart';
import '../../Utils/color_utils.dart';
import '../../Utils/mqtt_handler.dart';
import '../../Widgets/gradient_card.dart';

class FindAChargerWithPlanTripComponent extends StatelessWidget {
  final GlobalKey? widgetKey;
  FindAChargerWithPlanTripComponent({Key? key, this.widgetKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: size.width*0.05,vertical: size.height*0.02),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          CustomInkwell(
            onTap: (){
              CustomFocusManager.pinCodeFocusNode.unfocus();

              NavigatorUtils.navigateToMapScreen(context);
              },
            child: GradientCard(
              child: SizedBox(
                width: size.width*0.9,//0.55,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: size.width*0.07,
                      horizontal: size.width*0.07
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        getTranslated(context, "out_of_energy")!,
                        style: TextStyle(
                          fontSize: size.height*0.032,
                          fontFamily:  currentLanguageIsEnglish ? "Medium": "Arabic_Font",

                        ),
                      ),
                      SizedBox(height: size.height*0.03,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            getTranslated(context, "find_a_charger")!,
                            style: TextStyle(
                                fontSize: size.height*0.016,
                                color: Colors.black
                            ),
                          ),
                          SizedBox(width: size.width*0.06,),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: size.height*0.02,
                            color: Colors.grey[600],
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          // SizedBox(width: size.width*0.03,),
          // SizedBox(
          //   width: size.width*0.5,
          //   child: GradientCard(
          //     isBlack: true,
          //     child: Padding(
          //       padding: EdgeInsets.symmetric(
          //           vertical: size.width*0.07,
          //           horizontal: size.width*0.07
          //       ),
          //       child: Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           Text(
          //             getTranslated(context, "plan_you_trip")!,
          //             style: TextStyle(
          //                 fontSize: size.height*0.032,
          //                 fontFamily:  currentLanguageIsEnglish ? "Medium": "Arabic_Font",
          //                 color: kPrimaryColor
          //
          //             ),
          //           ),
          //           SizedBox(height: size.height*0.03,),
          //           Row(
          //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //             children: [
          //               Text(
          //                 getTranslated(context, "plan_it_now")!,
          //                 style: TextStyle(
          //                     fontSize: size.height*0.016,
          //                     color: Colors.white
          //                 ),
          //               ),
          //               SizedBox(width: size.width*0.06,),
          //               Icon(
          //                 Icons.arrow_forward_ios,
          //                 size: size.height*0.02,
          //                 color: Colors.white,
          //               )
          //             ],
          //           )
          //         ],
          //       ),
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}
