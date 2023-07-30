import 'package:flutter/material.dart';
import 'package:show_up_animation/show_up_animation.dart';

class CustomAnimationUp extends StatelessWidget {
  final Widget child;
  final int millisecond;
  final Direction direction;
  const CustomAnimationUp({Key? key, required this.child, required this.millisecond, this.direction = Direction.vertical}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShowUpAnimation(
      animationDuration: Duration(milliseconds: millisecond),
      curve: Curves.linearToEaseOut,
      direction: direction,
      offset: 0.5,
      child: child,
    );
  }
}
