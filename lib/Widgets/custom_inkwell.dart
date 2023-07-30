import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomInkwell extends StatelessWidget {
  final Widget child;
  final GestureTapCallback onTap;
  const CustomInkwell({Key? key, required this.child, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: onTap,
      child: child,
    );
  }
}
