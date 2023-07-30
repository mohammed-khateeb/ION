import 'package:flutter/material.dart';
import 'package:ion_application/Models/Api/location.dart';
import 'package:ion_application/Utils/extensions.dart';
import 'package:ion_application/Utils/main_utils.dart';
import 'package:ion_application/Widgets/custom_inkwell.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../Localization/current_language.dart';
import '../../Localization/language_constants.dart';
import '../../Utils/color_utils.dart';
import '../../Widgets/custom_button.dart';
import '../../Widgets/reusable_cached_network_image.dart';
import '../../Widgets/type_img_label_widget.dart';

class ChargeLocationComponent extends StatelessWidget {
  final LocationModel selectedLocation;
  const ChargeLocationComponent({Key? key, required this.selectedLocation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: size.width*0.02,
          vertical: size.height*0.01
      ),
      child: PageView(
        children: selectedLocation.sublocations!.map((subLocation) {
          return Container(
            padding: EdgeInsets.symmetric(
                horizontal: size.width*0.04,
                vertical: size.height*0.03
            ),

            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(size.height*0.02),
                  bottom: Radius.circular(size.height*0.01),
                )
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: size.width*0.5,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  currentLanguageIsEnglish?selectedLocation.name!:selectedLocation.nameAr!,
                                  style: TextStyle(
                                      fontSize: size.height*0.016,
                                      fontFamily:  currentLanguageIsEnglish ? "bold": "Arabic_Bold"
                                  ),
                                ),
                                Text(
                                  subLocation.description!,
                                  style: TextStyle(
                                      fontSize: size.height*0.015,
                                      color: Colors.grey
                                  ),
                                ),
                                if(selectedLocation.available==0&&selectedLocation.total==0&&selectedLocation.startTime==null)
                                  Padding(
                                    padding: EdgeInsets.only(
                                      top: size.height*0.005
                                    ),
                                    child: Text(
                                      getTranslated(context, "coming_soon")!,
                                      style: TextStyle(
                                          fontSize: size.height*0.015,
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ),
                                if(selectedLocation.available==0&&selectedLocation.total!>0&&selectedLocation.startTime==null)
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: size.height*0.005
                                    ),
                                    child: Text(
                                      getTranslated(context, "temporarily_unavailable")!,
                                      style: TextStyle(
                                          fontSize: size.height*0.015,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: size.height*0.056,
                            height: size.height*0.04,
                            child: Stack(
                              children: [
                                if(selectedLocation.startTime!=null&&DateTime.now().difference(selectedLocation.startTime!).inSeconds<3600)
                                  Align(
                                    alignment: AlignmentDirectional.centerEnd,
                                  child: SizedBox(
                                      height: size.height*0.03,
                                      child: CircularPercentIndicator(
                                        radius: size.height*0.015,
                                        lineWidth: 3.0,
                                        percent: double.parse((60-DateTime.now().difference(selectedLocation.startTime!).inMinutes).toStringAsFixed(0))/60,
                                        reverse: false,
                                        center: Text(
                                          (59-DateTime.now().difference(selectedLocation.startTime!).inMinutes).toStringAsFixed(0),
                                          style: TextStyle(
                                              fontSize: size.height*0.015,
                                              color: Colors.grey[800],
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),
                                        backgroundColor: Colors.transparent,
                                        progressColor: kPrimaryColor,
                                      ),
                                    ),
                                  ),
                                  // Align(
                                //   alignment: AlignmentDirectional.centerEnd,
                                //   child: CircularCountDownTimer(
                                //     duration: 3600,
                                //     initialDuration:DateTime.now().difference(selectedLocation.startTime!).inSeconds,
                                //     controller: CountDownController(),
                                //     height: size.height*0.03,
                                //     width: size.height*0.03,
                                //     ringColor: Colors.transparent,
                                //     ringGradient: null,
                                //     fillColor: kPrimaryColor,
                                //     fillGradient: null,
                                //     backgroundColor: Colors.transparent,
                                //     backgroundGradient: null,
                                //     strokeWidth: size.height*0.004,
                                //     strokeCap: StrokeCap.round,
                                //     textStyle: TextStyle(
                                //         fontSize: size.height*0.017,
                                //         color: Colors.black,
                                //         fontFamily:  currentLanguageIsEnglish ? "bold": "Arabic_Bold"
                                //     ),
                                //     textFormat: CountdownTextFormat.S,
                                //     isReverse: true,
                                //     isReverseAnimation: true,
                                //     isTimerTextShown: true,
                                //     autoStart: true,
                                //     onStart: () {
                                //       debugPrint('Countdown Started');
                                //     },
                                //     onComplete: () {
                                //       debugPrint('Countdown Ended');
                                //     },
                                //     onChange: (String timeStamp) {
                                //       debugPrint('Countdown Changed $timeStamp');
                                //     },
                                //     timeFormatterFunction: (defaultFormatterFunction, duration) {
                                //       if (duration.inSeconds == 0) {
                                //         return "";
                                //       } else {
                                //         return duration.inMinutes+1;
                                //       }
                                //     },
                                //   ),
                                // ),
                                if(selectedLocation.available!>0)
                                Positioned.fill(
                                  child: Align(
                                    alignment: AlignmentDirectional.centerStart,
                                    child: Container(
                                      height: size.height*0.03,
                                      width: size.height*0.03,
                                      decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(0xff13E74E)
                                      ),
                                      child: Center(
                                        child: Text(
                                          "${selectedLocation.available!}",
                                          style: TextStyle(
                                              fontSize: size.height*0.017,
                                              color: Colors.white,
                                              fontFamily:  currentLanguageIsEnglish ? "bold": "Arabic_Bold"
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Wrap(
                              children: selectedLocation.plugTypes!.toJson().map((type) {
                                return TypeImgLabelWidget(type: type,);
                              }).toList(),
                            ),
                          ),
                          if(selectedLocation.tariff!=null)
                            Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                getTranslated(context, "tariff")!,
                                style: TextStyle(
                                    fontSize: size.height*0.016,
                                    color: Colors.grey[600]
                                ),
                              ),
                              Text(
                                "${selectedLocation.tariff!.getTariffValue()} ${getTranslated(context, "jod")}",
                                style: TextStyle(
                                    fontSize: size.height*0.016,
                                    fontFamily:  currentLanguageIsEnglish ? "bold": "Arabic_Bold"
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: size.height*0.02,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // CustomButton(
                          //   label: getTranslated(context, "book_now")!,
                          //   width: size.width*0.28,
                          //   fontSize: size.height*0.015,
                          //   height: size.height*0.038,
                          //   borderRadiusValue: size.height*0.005,
                          //   border: Border.all(color: kPrimaryColor),
                          //   withShadow: false,
                          //   color: Colors.transparent,
                          //   textColor: Colors.black,
                          //   onPressed: (){},
                          // ),
                          CustomInkwell(
                            onTap: (){
                              MainUtils.navigateToMap(selectedLocation.latLng!.latitude!, selectedLocation.latLng!.longitude!);
                            },
                            child: Container(
                              width: size.width*0.15,
                              height: size.height*0.038,
                              decoration: BoxDecoration(
                                  color: kPrimaryColor,
                                  borderRadius: BorderRadius.circular(size.height*0.005)
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(size.height*0.007),
                                child: Image.asset(
                                  "assets/icons/navigation.png",
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: size.width*0.02,),
                Expanded(
                  child:selectedLocation.sublocations?.first.img?.first==null
                      ?Image.asset(
                    "assets/images/logo.png",
                    height: size.height * 0.1,
                  )
                      : ReusableCachedNetworkImage(
                    height: size.height*0.3,
                    imageUrl: selectedLocation.sublocations?.first.img?.first,
                    fit: BoxFit.fill,
                    borderRadius: BorderRadius.horizontal(
                        right: Radius.circular(Localizations.localeOf(context).languageCode=="ar"?0:size.height*0.02),
                        left: Radius.circular(Localizations.localeOf(context).languageCode=="en"?0:size.height*0.02)
                    ),
                  ),
                )
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
