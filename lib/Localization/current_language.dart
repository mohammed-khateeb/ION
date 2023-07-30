import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';
import 'language_constants.dart';

bool currentLanguageIsEnglish = true;

void checkCurrentLanguage() async {
  String languageCode = Platform.localeName.split("_").first;
  if (languageCode == 'en') {
    currentLanguageIsEnglish = true;
  } else {
    currentLanguageIsEnglish = false;
  }
}
