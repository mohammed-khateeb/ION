import 'package:flutter/material.dart';
import '../../Screens/splash_screen.dart';
import '../../Screens/tuturials_screen.dart';
import 'route_constants.dart';

class CustomRouter {
  static Route<dynamic>? generatedRoute(RouteSettings settings) {
    switch (settings.name) {
      case start:
        return MaterialPageRoute(builder: (_) => const SplashScreen(),settings: RouteSettings(name: "start"));

    }
    return null;
  }


}
