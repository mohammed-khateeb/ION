import 'package:intl/intl.dart';
import 'package:ion_application/Localization/current_language.dart';

extension FormatDateTime on DateTime {

  String dateTimeFormat({DateFormat? formatter,bool inArabic = false,bool withNewLine = true}) {
    formatter ??= DateFormat.MMMM(inArabic?'ar':'en_US');
    DateFormat formatWithNewLine = DateFormat.d(inArabic?'ar':'en_US');
    DateFormat format = DateFormat("d ,yyyy",inArabic?'ar':'en_US');
    final String formatted = "${formatter.format(this)} ${withNewLine?"\n":""}${withNewLine?formatWithNewLine.format(this):format.format(this)} ${withNewLine&&currentLanguageIsEnglish?"th":""}";

    return formatted;
  }

  String timeFormat({DateFormat? formatter,bool inArabic = false}) {
    formatter ??= DateFormat.Hm(inArabic?'ar':'en_US');
    final String formatted = formatter.format(this);

    return formatted;
  }
}
