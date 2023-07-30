

import 'dart:io';

import 'package:flutter_udid/flutter_udid.dart';

class DeviceUtils{
  static Future<String?> getDeviceId() async {
    try{
      return await FlutterUdid.udid;
    }
    catch(_){
      return null;
    }
  }

}
