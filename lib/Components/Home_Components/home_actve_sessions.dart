import 'package:flutter/material.dart';
import 'package:ion_application/Controller/transactions_controller.dart';
import 'package:ion_application/Utils/date_utils.dart';
import 'package:ion_application/Utils/main_utils.dart';
import 'package:ion_application/Widgets/waiting_widget.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../Localization/current_language.dart';
import '../../Localization/language_constants.dart';
import '../../Models/Api/transactions.dart';
import '../../Utils/color_utils.dart';
import '../../Utils/mqtt_handler.dart';
import '../../Widgets/custom_page_view.dart';
import '../../Widgets/gradient_card.dart';

class HomeActiveSession extends StatefulWidget {

  const HomeActiveSession(
      {Key? key, })
      : super(key: key);

  @override
  State<HomeActiveSession> createState() => HomeActiveSessionState();
}

class HomeActiveSessionState extends State<HomeActiveSession> {

  bool sessionStarted = false;

  final TransformerPageController _pageController = TransformerPageController();
  bool showIndicator = true;
  MqttHandler? mqttHandler;
  List<int>? activeSessionsIds;


  sessionCharged() {
      if(sessionStarted==true){
        setState(() {
          sessionStarted = false;
        });
      }
  }


  void _pageScrollListener() {
    if (_pageController.page!.round() != _pageController.page) {
      setState(() {
        showIndicator = true;
      });
    } else {
      setState(() {
        showIndicator = false;
      });
    }
  }


  @override
  void initState() {
    MainUtils.navKey.currentContext!.read<TransactionsController>().getSessionActive().then((value) {
      setState(() {
        activeSessionsIds = value;
      });
    });
    MainUtils.navKey.currentContext!.read<MqttHandler>().addListener(() {
      if(MainUtils.navKey.currentContext!.read<MqttHandler>().sessionData.value.isNotEmpty) {
        sessionCharged();
      }
    });

    _pageController.addListener(_pageScrollListener);
    super.initState();
  }


  startSession(){
    Future.delayed(Duration.zero).then((value) {
      setState(() {
        sessionStarted = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<Transaction> activeTransactions = context.watch<MqttHandler>().sessionData.value;

    return sessionStarted
        ?GradientCard(
      borderRadiusValue: size.height * 0.008,
      child: const Center(
        child: WaitingWidget(isThreeBounce: true,),
      ),
    )
        :activeSessionsIds==null
        ?GradientCard(
      borderRadiusValue: size.height * 0.008,
      child: const Center(
        child: WaitingWidget(isThreeBounce: true),
      ),
    )
        : activeTransactions.isEmpty
        ? GradientCard(
      borderRadiusValue: size.height * 0.008,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: EdgeInsetsDirectional.only(
                    top: size.height * 0.012,
                    end: size.height * 0.012),
                height: size.height * 0.013,
                width: size.height * 0.013,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Colors.red),
              ),
            ],
          ),
          SizedBox(
            height: size.height * 0.065,
          ),
          Center(
            child: Padding(
              padding: EdgeInsetsDirectional.only(
                  start: size.width * 0.03),
              child: Text(
                getTranslated(context, "no_active_session")!,
                style: TextStyle(
                    fontSize: size.height * 0.016,
                    color: Colors.grey[600]),
              ),
            ),
          ),
        ],
      ),
    )
        : Stack(
          children: [
            PageView.builder(
              controller: _pageController,
      itemCount: activeTransactions.length,
      itemBuilder: (_,index){
            return GradientCard(
              borderRadiusValue: size.height * 0.008,
              child: Container(
                padding: EdgeInsetsDirectional.only(
                    start: size.width * 0.025,
                    end: size.width * 0.025,
                    bottom: size.height * 0.01),
                width: size.width * 0.38,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: size.height*0.005,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [

                        if(activeTransactions[index].startDate!=null&&
                            double.parse((60-DateTime.now().difference(activeTransactions[index].startDate!).inMinutes).toStringAsFixed(0))/60>0
                            &&double.parse((60-DateTime.now().difference(activeTransactions[index].startDate!).inMinutes).toStringAsFixed(0))/60<=1)
                        Padding(
                          padding:  EdgeInsets.only(top: size.height*0.005),
                          child: SizedBox(
                            height: size.height*0.03,
                            child: CircularPercentIndicator(

                              radius: size.height*0.015,
                              lineWidth: 2.0,
                              percent: double.parse((60-DateTime.now().difference(activeTransactions[index].startDate!).inMinutes).toStringAsFixed(0))/60,
                              reverse: false,
                              center: Text(
                                (59-DateTime.now().difference(activeTransactions[index].startDate!).inMinutes).toStringAsFixed(0),
                                style: TextStyle(
                                    fontSize: size.height*0.015,
                                    color: Colors.grey[800],
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              backgroundColor: Colors.transparent,
                              progressColor: Colors.green,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: size.height * 0.005,
                    ),
                    if (activeTransactions[index].amount != null)
                      RichText(
                        textAlign: TextAlign.start,
                        text: TextSpan(
                          text: activeTransactions[index].amount!.toStringAsFixed(2),
                          style:  TextStyle(
                            fontSize: size.height * 0.022,
                            color: Colors.black,
                            fontFamily:  currentLanguageIsEnglish ? "bold": "Arabic_Bold",
                          ),
                          children:  <TextSpan>[
                            TextSpan(text: " ${getTranslated(context, "jod")!}", style: TextStyle(fontFamily: currentLanguageIsEnglish?"regular":"Arabic_Font",fontSize: size.height*0.017)),
                          ],
                        ),
                      ),
                    if (activeTransactions[index].kwh != null)
                      RichText(
                        textAlign: TextAlign.start,
                        text: TextSpan(
                          text: activeTransactions[index].kwh!.toStringAsFixed(2),
                          style:  TextStyle(
                            fontSize: size.height * 0.022,
                            color: Colors.black,
                            fontFamily:  currentLanguageIsEnglish ? "Regular": "Arabic_Font",
                          ),
                          children:  <TextSpan>[
                            TextSpan(text: " ${getTranslated(context, "kw")!}", style: TextStyle(fontFamily: currentLanguageIsEnglish?"regular":"Arabic_Font",fontSize: size.height*0.013)),
                          ],
                        ),
                      ),
                    SizedBox(height: size.height*0.01,),
                    if(activeTransactions[index].startDate!=null)
                    Text(
                      "${getTranslated(context, "start_at")!}: ${activeTransactions[index].startDate!.timeFormat(inArabic: !currentLanguageIsEnglish)}",
                      style: TextStyle(
                        fontSize: size.height * 0.012,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            );
      },
    ),
            if(activeTransactions.isNotEmpty&&activeTransactions.length>1)
            AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: showIndicator?1:0,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SmoothPageIndicator(
                  controller: _pageController,  // PageController
                  count:  activeTransactions.length,
                  effect:   WormEffect(
                    radius: 0,
                    dotHeight: size.height*0.002,
                    spacing: 0,
                    offset: 0,
                    dotWidth: size.width*0.3/activeTransactions.length,
                    activeDotColor: kPrimaryColor,
                    dotColor: Colors.grey[400]!,
                  ),  // your preferred effect
                ),
              ),
            )
          ],
        );
  }
}
