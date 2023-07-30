import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ion_application/Localization/language_constants.dart';
import 'package:ion_application/Widgets/custom_inkwell.dart';
import 'package:ion_application/Widgets/gradient_card.dart';

import '../../Localization/current_language.dart';

class MyCarComponent extends StatelessWidget {
  MyCarComponent({Key? key}) : super(key: key);
  // ExpandableController expandableController =
  // ExpandableController(initialExpanded: false);


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsetsDirectional.only(start: size.width*0.05),
      child: CustomInkwell(
        onTap: (){
          //expandableController.toggle();

        },
        child: GradientCard(
          child: Column(
            children: [
              SizedBox(height: size.height*0.02,),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width*0.03
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          getTranslated(context, "my_car")!,
                          style: TextStyle(
                            fontSize: size.height*0.019,
                            fontFamily:  currentLanguageIsEnglish ? "Medium": "Arabic_Font"
                          ),
                        ),
                        Text(
                          "BMW i3",
                          style: TextStyle(
                              fontSize: size.height*0.019,
                              fontFamily:  currentLanguageIsEnglish ? "bold": "Arabic_Bold"
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.fromLTRB(size.width*0.03, 0, size.width*0.03, size.height*0.012),
                        height: 1,
                        color: Colors.black,
                      ),
                    ),
                    Image.network(
                      "https://upload.wikimedia.org/wikipedia/commons/thumb/f/f4/BMW_logo_%28gray%29.svg/2048px-BMW_logo_%28gray%29.svg.png",
                      height: size.height*0.03,
                    )
                  ],
                ),
              ),
              SizedBox(height: size.height*0.02,),
              Padding(
                padding: EdgeInsetsDirectional.only(
                  start: size.width*0.03
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: size.width*0.25,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    getTranslated(context, "plug_type")!,
                                    style: TextStyle(
                                        fontSize: size.height*0.019,
                                        fontFamily:  currentLanguageIsEnglish ? "Medium": "Arabic_Font"
                                    ),
                                  ),
                                  Text(
                                    "SAE-J1772",
                                    style: TextStyle(
                                        fontSize: size.height*0.019,
                                        fontFamily:  currentLanguageIsEnglish ? "bold": "Arabic_Bold"
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Image.asset(
                              "assets/icons/plug_type.png",
                              height: size.height*0.04,
                            )
                          ],
                        ),
                        SizedBox(height: size.height*0.02,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SizedBox(
                              width: size.width*0.25,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    getTranslated(context, "power")!,
                                    style: TextStyle(
                                        fontSize: size.height*0.019,
                                        fontFamily:  currentLanguageIsEnglish ? "Medium": "Arabic_Font"
                                    ),
                                  ),
                                  Text(
                                    "7.2 ${getTranslated(context, "kw")}",
                                    style: TextStyle(
                                        fontSize: size.height*0.019,
                                        fontFamily:  currentLanguageIsEnglish ? "bold": "Arabic_Bold"
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Image.asset(
                              "assets/icons/low_battery.png",
                              height: size.height*0.015,
                            )
                          ],
                        ),
                        SizedBox(height: size.height*0.01,),
                      ],
                    ),
                    SizedBox(width: size.width*0.05,),
                    Expanded(
                      child: Image.asset(
                        "assets/images/test_car.png",
                        height: size.height*0.15,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
              // ExpandablePanel(
              //   controller: expandableController,
              //   theme: ExpandableThemeData(
              //     iconColor: Colors.grey[600]!,
              //     iconPadding: EdgeInsets.symmetric(
              //         horizontal: size.width * 0.03),
              //     headerAlignment:
              //     ExpandablePanelHeaderAlignment.center,
              //     iconPlacement: ExpandablePanelIconPlacement.left
              //   ),
              //   header: SizedBox(
              //     height: size.height*0.02,
              //   ),
              //   collapsed: const SizedBox(),
              //   expanded: Padding(
              //     padding:  EdgeInsets.only(
              //       left: size.width*0.03,
              //       right: size.width*0.03,
              //       bottom: size.height*0.01
              //     ),
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //       children: [
              //         Row(
              //           children: [
              //             Text(
              //               getTranslated(context, "battery_level")!,
              //               style: TextStyle(
              //                   fontSize: size.height*0.01,
              //                   fontFamily:  currentLanguageIsEnglish ? "bold": "Arabic_Bold"
              //               ),
              //             ),
              //             SizedBox(width: size.width*0.01,),
              //             Padding(
              //               padding: EdgeInsets.only(bottom: size.height*0.001),
              //               child: Image.asset(
              //                 "assets/icons/battery_full.png",
              //                 height: size.height*0.01,
              //               ),
              //             ),
              //             SizedBox(width: size.width*0.01,),
              //
              //             Text(
              //               "95%",
              //               style: TextStyle(
              //                   fontSize: size.height*0.01,
              //                   fontFamily:  currentLanguageIsEnglish ? "bold": "Arabic_Bold"
              //               ),
              //             ),
              //           ],
              //         ),
              //         Row(
              //           children: [
              //             Text(
              //               getTranslated(context, "range")!,
              //               style: TextStyle(
              //                   fontSize: size.height*0.01,
              //                   fontFamily:  currentLanguageIsEnglish ? "bold": "Arabic_Bold"
              //               ),
              //             ),
              //             SizedBox(width: size.width*0.01,),
              //             Padding(
              //               padding: EdgeInsets.only(bottom: size.height*0.001),
              //               child: Image.asset(
              //                 "assets/icons/range.png",
              //                 height: size.height*0.01,
              //               ),
              //             ),
              //             SizedBox(width: size.width*0.01,),
              //
              //             Text(
              //               "100 KM",
              //               style: TextStyle(
              //                   fontSize: size.height*0.01,
              //                   fontFamily:  currentLanguageIsEnglish ? "bold": "Arabic_Bold"
              //               ),
              //             ),
              //           ],
              //         ),
              //       ],
              //     ),
              //   )
              // ),

            ],
          ),
        ),
      ),
    );
  }
}
