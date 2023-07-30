import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

import '../../Localization/current_language.dart';
import '../../Localization/language_constants.dart';
import '../../Widgets/custom_inkwell.dart';
import '../../Widgets/gradient_card.dart';

class FilterTypeComponent extends StatefulWidget {
  final Function({String? type}) onSelectType;

  const FilterTypeComponent({Key? key, required this.onSelectType}) : super(key: key);

  @override
  State<FilterTypeComponent> createState() => FilterTypeComponentState();
}

class FilterTypeComponentState extends State<FilterTypeComponent> {
  ExpandableController controller = ExpandableController();
  bool arrowTop = false;


  collapseWidget(){
    controller.value = false;
    setState(() {
      arrowTop = false;
    });
  }


  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      if(controller.value){
        setState(() {
          arrowTop = true;
        });
      }
      else{
        setState(() {
          arrowTop = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GradientCard(
      borderRadiusValue: size.height*0.01,
          child: SizedBox(
            width: size.width*0.18,
            child: Column(
              children: [
                ExpandablePanel(
                controller: controller,
                theme: ExpandableThemeData(
                    iconColor: Colors.grey[600]!,
                    iconPadding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.0),
                    headerAlignment:
                    ExpandablePanelHeaderAlignment.center,
                  hasIcon: false
                ),
                header: Padding(
                  padding: EdgeInsets.only(
                    top: size.height * 0.01,
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: size.height*0.02,),
                      Image.asset(
                        "assets/icons/filter.png",
                        height: size.height*0.02,
                      ),
                      SizedBox(height: size.height*0.01,),

                    ],
                  ),
                ),
                collapsed: const SizedBox(),
                expanded: Padding(
                  padding:  EdgeInsets.only(
                      left: size.width*0.03,
                      right: size.width*0.03,
                      bottom: size.height*0.01
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: size.height*0.02,),
                      CustomInkwell(
                        onTap: () {
                          controller.value = false;
                          widget.onSelectType(
                              type: "J1772-1");
                        },
                        child: Column(
                          children: [
                            Image.asset(
                              "assets/icons/filter_type_J1772-1.png",
                              height: size.height * 0.035,
                            ),
                            SizedBox(
                              height: size.height * 0.005,
                            ),
                            Text(
                              "Type 1",
                              style: TextStyle(
                                  fontSize: size.height * 0.012,
                                  fontFamily: "Bold",

                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      CustomInkwell(
                        onTap: () {
                          controller.value = false;

                          widget.onSelectType(type: "J1772-2");

                        },
                        child: Column(
                          children: [
                            Divider(
                              indent: size.width * 0.02,
                              endIndent: size.width * 0.02,
                            ),
                            Image.asset(
                              "assets/icons/filter_type_J1772-2.png",
                              height: size.height * 0.035,
                            ),
                            SizedBox(
                              height: size.height * 0.005,
                            ),
                            Text(
                              "Type 2",
                              style: TextStyle(
                                  fontSize:
                                  size.height * 0.012,
                                  fontFamily: "Bold",

                                  fontWeight:
                                  FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            Divider(
                              indent: size.width * 0.02,
                              endIndent: size.width * 0.02,
                            ),
                          ],
                        ),
                      ),
                      CustomInkwell(
                        onTap: () {
                          controller.value = false;

                          widget.onSelectType(type: "CHAdeMO");
                        },
                        child: Column(
                          children: [
                            Image.asset(
                              "assets/icons/filter_type_CHAdeMO.png",
                              height: size.height * 0.035,
                            ),
                            SizedBox(
                              height: size.height * 0.005,
                            ),
                            Text(
                              "GB/T",
                              style: TextStyle(
                                  fontSize:
                                  size.height * 0.012,
                                  fontFamily: "Bold",
                                  fontWeight:
                                  FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            Divider(
                              indent: size.width * 0.02,
                              endIndent: size.width * 0.02,
                            ),
                          ],
                        ),
                      ),
                      CustomInkwell(
                        onTap: () {
                          controller.value = false;

                          widget.onSelectType();
                        },
                        child: Column(
                          children: [
                            Text(
                              "All",
                              style: TextStyle(
                                  fontSize:
                                  size.height * 0.017,
                                  color: Colors.black,
                                  fontFamily: "bold"),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              "Types",
                              style: TextStyle(
                                  fontSize:
                                  size.height * 0.012,
                                  color: Colors.black,
                                  fontWeight:
                                  FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            Divider(
                              indent: size.width * 0.02,
                              endIndent: size.width * 0.02,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
    ),
                CustomInkwell(
                  onTap: () {
                    controller.value = !controller.value;
                  },
                  child: Icon(
                    arrowTop?Icons.keyboard_arrow_up:Icons.keyboard_arrow_down,
                    size: size.height * 0.04,
                  ),
                )
              ],
            ),
          ),
        );
  }
}
