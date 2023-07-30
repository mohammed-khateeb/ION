import 'package:flutter/material.dart';

class TutorialComponent extends StatelessWidget {
  final int index;
  final PageController pageController;
  const TutorialComponent({Key? key, required this.index, required this.pageController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Image.asset(
      "assets/images/tutorial_$index.png",
      fit: BoxFit.contain,
      height: size.height,
      width: size.width,
    );
  }
}
