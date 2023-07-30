import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../Localization/language_constants.dart';
import '../Utils/color_utils.dart';

class WaitingWidget extends StatelessWidget {
  final bool isThreeBounce;
  const WaitingWidget({
    Key? key,this.isThreeBounce=false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return isThreeBounce
        ? SpinKitThreeBounce(
      color: kPrimaryColor,
      size: size.height*0.03,
    )
        : SpinKitDualRing(
      color: kPrimaryColor,
      size: 50.0,
      lineWidth: 5,
    );
  }
}