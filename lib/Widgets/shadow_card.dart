import 'package:flutter/material.dart';

class ShadowCard extends StatelessWidget {
  final Color? color;
  final double? width;
  final bool isCircle;
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? borderRadius;
  const ShadowCard(
      {Key? key,
      this.color,
      this.width,
      required this.child,
      this.padding,
      this.margin,
      this.borderRadius,
      this.isCircle = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: padding,
      margin: margin,
      width: width,
      decoration: BoxDecoration(
        color: color ?? Colors.white,
        shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: isCircle
            ? null
            : BorderRadius.circular(borderRadius ?? size.height * 0.01),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: size.height * 0.01,
            offset: const Offset(0, 0.75), // changes position of shadow
          ),
        ],
      ),
      child: child,
    );
  }
}
