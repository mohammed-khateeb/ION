import 'package:flutter/material.dart';

class GradientCard extends StatelessWidget {
  final Widget? child;
  final bool isCircle;
  final double? borderRadiusValue;
  final bool? isBlack;
  final bool shadowToLeft;
  final bool? isTransparent;

  final Color? borderColor;
  const GradientCard({Key? key,this.shadowToLeft = false, this.child, this.isCircle = false, this.borderRadiusValue, this.isBlack, this.borderColor, this.isTransparent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration:  BoxDecoration(
        border:borderColor!=null? Border.all(color: borderColor!):null,
        shape: isCircle? BoxShape.circle:BoxShape.rectangle,
        borderRadius:isCircle?null: BorderRadius.circular(borderRadiusValue??size.height*0.02),
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors:isTransparent==true
                ?[
                  Colors.transparent,
              Colors.transparent,
            ]
                : isBlack==true
                ? [
             Color(0xff121212),
              Color(0xff121212)
            ]
                :[
              Color(0xffE5E6EC),
              Colors.white
            ]
        ),
        boxShadow: isTransparent==true?[]:[
          BoxShadow(
            color: Colors.black.withOpacity(shadowToLeft?0.04:0.05),
            spreadRadius: 2,
            blurRadius: 5,
            offset:  Offset(shadowToLeft?-3:4,shadowToLeft?4:2), // changes position of shadow
          ),
        ],
      ),
      child: child,
    );
  }
}
