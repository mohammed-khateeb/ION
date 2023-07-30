import 'package:flutter/material.dart';

import '../Localization/language_constants.dart';
import '../Utils/color_utils.dart';
import '../Utils/main_utils.dart';
import '../Widgets/custom_button.dart';

class AppNeedUpdateDialog extends StatelessWidget {
  String? url;
  bool? showRemindMeLaterButton;
  Function? onClickRemindMeLaterButton;

  AppNeedUpdateDialog(
      {Key? key,
        this.url,
        this.showRemindMeLaterButton,
        this.onClickRemindMeLaterButton})
      : super(key: key);

  @override
  Widget build(
      BuildContext context) {
    Size size = MediaQuery.of(MainUtils.navKey.currentContext!).size;

    bool isTablet =
        MediaQuery.of(MainUtils.navKey.currentContext!).size.shortestSide >=
            550;

    return WillPopScope(
      onWillPop: ()async=>false,
      child: AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0))),
        titlePadding: EdgeInsetsDirectional.only(
            end: size.height * 0.015,
            top: isTablet ? size.height * 0.0 : size.height * 0.015),
        insetPadding: isTablet
            ? EdgeInsets.only(
            left: size.width * 0.21,
            right: size.width * 0.21,
            top: size.height * 0.21,
            bottom: size.height * 0.21)
            : const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
        contentPadding: EdgeInsets.symmetric(
            vertical: isTablet ? size.height * 0.0 : size.height * 0.022,
            horizontal: isTablet ? size.width * 0.0 : size.width * 0.035),
        content: Padding(
          padding: isTablet
              ? EdgeInsetsDirectional.only(bottom: size.height * 0.03)
              : const EdgeInsets.all(0.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: size.height * 0.005,
              ),
              Icon(
                Icons.warning_amber_outlined,
                color: kPrimaryColor,
                size: size.height * 0.1,
              ),
              SizedBox(
                height: size.height * 0.005,
              ),
              Padding(
                padding: isTablet
                    ? EdgeInsetsDirectional.only(
                    start: size.width * 0.04, end: size.width * 0.04)
                    : const EdgeInsetsDirectional.all(0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: size.height * 0.035,
                    ),
                    Text(
                      getTranslated(context, "update_app")!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: size.height * 0.0195,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: size.height * 0.015,
                    ),
                    Text(
                      getTranslated(context, 'update_msg')!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: size.height * 0.0195,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: size.height * 0.045,
                    ),
                    CustomButton(
                      width: size.width * 0.41,
                      height: size.height * 0.047,
                      label: getTranslated(context, 'update_now')!,
                      onPressed: () {
                        MainUtils.openBrowser(url!);
                      },
                    ),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    showRemindMeLaterButton!
                        ? CustomButton(
                      width: size.width * 0.41,
                      height: size.height * 0.047,
                      label: getTranslated(context, 'remind_me_later')!,
                      onPressed: () {
                        Navigator.pop(context);

                        onClickRemindMeLaterButton!();
                      },
                    )
                        : const SizedBox(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }


}