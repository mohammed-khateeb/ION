import 'package:flutter/material.dart';
import 'package:ion_application/Controller/charger_controller.dart';
import 'package:ion_application/Localization/language_constants.dart';
import 'package:ion_application/Models/Responses/httpresponse.dart';
import 'package:ion_application/Utils/main_utils.dart';
import 'package:ion_application/Utils/navigtor_utils.dart';
import 'package:ion_application/Widgets/custom_inkwell.dart';
import 'package:ion_application/Widgets/gradient_card.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../Utils/color_utils.dart';
import '../../Utils/user_utils.dart';
import 'home_actve_sessions.dart';

class CustomFocusManager {
  static FocusNode pinCodeFocusNode = FocusNode();
}

class PinCodeWithLastSession extends StatefulWidget {

  const PinCodeWithLastSession({Key? key, }) : super(key: key);

  @override
  State<PinCodeWithLastSession> createState() => _PinCodeWithLastSessionState();
}

class _PinCodeWithLastSessionState extends State<PinCodeWithLastSession> {

  final GlobalKey<HomeActiveSessionState> _widgetKey = GlobalKey();

  final TextEditingController controller = TextEditingController();


  @override
  void initState() {
    CustomFocusManager.pinCodeFocusNode = FocusNode();
    super.initState();
  }


  @override
  void dispose() {

    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height*0.15,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width*0.05),
        child: Row(
          children: [
            Expanded(
              child: GradientCard(
                borderRadiusValue: size.height*0.01,
                child: Padding(
                  padding: EdgeInsets.only(
                      top: size.width*0.03,
                      right: size.width*0.03,
                      left: size.width*0.03
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            getTranslated(context, "enter_new_pin")!,
                            style: TextStyle(
                                fontSize: size.height*0.018
                            ),
                          ),
                          CustomInkwell(
                            onTap: () async {
                              CustomFocusManager.pinCodeFocusNode.unfocus();
                              NavigatorUtils.navigateToScannerScreen(context);
                            },
                            child: Image.asset(
                              "assets/icons/qr_code.png",
                              height: size.height*0.04,
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: size.height*0.025,),
                      Row(
                        children: [
                          SizedBox(
                            width: size.width*0.5,
                            child: Directionality(
                              textDirection: TextDirection.ltr,
                              child: PinCodeTextField(
                                appContext: context,
                                focusNode: CustomFocusManager.pinCodeFocusNode,
                                enablePinAutofill: false,
                                pastedTextStyle: TextStyle(
                                  color: Colors.green.shade600,
                                  fontWeight: FontWeight.bold,
                                ),
                                length: 4,
                                obscureText: false,
                                obscuringCharacter: '*',

                                blinkWhenObscuring: true,
                                animationType: AnimationType.fade,

                                controller: controller,
                                pinTheme: PinTheme(
                                    shape: PinCodeFieldShape.box,
                                    activeColor: Colors.grey,
                                    activeFillColor: Colors.white,
                                    inactiveColor: Colors.grey,
                                    selectedColor: kPrimaryColor,
                                    selectedFillColor: Colors.white,
                                    inactiveFillColor: Colors.white,
                                    borderRadius: BorderRadius.circular(5),
                                    borderWidth: 1,
                                    fieldWidth: size.height*0.04,
                                    fieldHeight: size.height*0.04,
                                ),

                                cursorColor: Colors.black,
                                animationDuration: const Duration(milliseconds: 300),
                                enableActiveFill: true,
                                keyboardType: TextInputType.number,

                                onCompleted: (pin){
                                  startCharge(context,int.parse(pin));
                                },

                                onChanged: (value) {
                                },
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: size.width*0.03,),
            Container(
              color: Colors.white,
              width: size.width*0.3,
              child: HomeActiveSession(key:_widgetKey,),
            ),
          ],
        ),
      ),
    );
  }


  startCharge(BuildContext context,int pin)async{

    MainUtils.showWaitingProgressDialog();
    HttpResponse response = await context.read<ChargerController>().startCharger(pin);
    MainUtils.hideWaitingProgressDialog();

    if(response.isSuccess == true){
      _widgetKey.currentState?.startSession();
      MainUtils.showSuccessAlertDialog(context,getTranslated(context, "session_started")!);

      //widget.whenStartSession();
      controller.clear();
    }
    else if(response.responseCode == 401 ){
      MainUtils.showErrorAlertDialog(context,getTranslated(MainUtils.navKey.currentContext!, "session_timeout")!);
      Future.delayed(Duration(milliseconds: 800)).then((value) {
        NavigatorUtils.navigateToSplashScreen(MainUtils.navKey.currentContext!);

      });

    }
    else {
    MainUtils.showErrorAlertDialog(context,response.message!);
    controller.clear();

    }
  }
}
