import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
extension StrongPassword on String {
  bool isStrongPassword() {
    return RegExp(r"(?=.*[a-z])(?=.*[A-Z])(?=.*?[0-9])(?=.*?[!@_#\:,$&/*~.;])\w+")
        .hasMatch(this);
  }
}

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}

extension DateHelpers on DateTime {
  bool isAcceptTimePicked(DateTime pickedTime,TimeOfDay time) {

    return ((time.hour > hour||((time.minute > minute||time.minute == minute)&&time.hour==hour)) &&
        pickedTime.day == day)||
        pickedTime.day > day;
  }
}

extension DateFromString on String {
  DateTime getDateFromString(){
    if(contains("GMT")){
      String date = split(" GMT").first;
      return intl.DateFormat("EEE MMM dd yyyy HH:mm:ss").parse(date);
    }
    else{
      return DateTime.parse(this);
    }
  }
}

extension TariffValue on int {
  String getTariffValue(){
    double value = this/1000;
    if(value.toStringAsFixed(3).split(".").last[2]!="0"){
      return value.toStringAsFixed(3);
    }
    else if(value.toStringAsFixed(2).split(".").last[1]!="0"){
      return value.toStringAsFixed(2);
    }
    else if(value.toStringAsFixed(1).split(".").last!="0"){
      return value.toStringAsFixed(1);
    }
    else {
      return value.toStringAsFixed(0);
    }

  }
}