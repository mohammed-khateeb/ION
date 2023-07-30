import 'dart:io';

import 'package:dio/dio.dart';
import '../Api/api_client.dart';
import '../Models/Responses/httpresponse.dart';
import '../Models/Responses/standard_response.dart';
import '../Utils/version_utils.dart';

class VersionServices {
  Dio? _dio;

  VersionServices({bool userV3 = true}) {
    _dio = ApiClient.getDio(useV3: userV3);
  }


  Future<HttpResponse<bool>> checkVersion() async {
    try {

      final response = await _dio!.get(
          "/check_version?platform=${Platform.isAndroid ? "android" : "ios"}&version=${PackageInfoConst.versionName??(Platform.isAndroid ? androidVersion : iosVersion)}");

      if (response.statusCode == 200) {
        StandardResponse standardResponse =
            StandardResponse.fromJson(response.data);
        return HttpResponse(
            isSuccess: true,
            data: standardResponse.message == "true",
            message: standardResponse.message,
            responseCode: 400);
      } else {
        StandardResponse standardResponse =
            StandardResponse.fromJson(response.data);
        return HttpResponse(
            isSuccess: true,
            message: standardResponse.message,
            responseCode: 400);
      }
    } catch (e) {
      if (e is DioError) {
        if (e.message!=null&&e.message!.contains("SocketException")) {
          return HttpResponse(
              isSuccess: false,
              message: "Connection Failed",
              responseCode: 500);
        } else if (e.response != null) {
          return HttpResponse(
              isSuccess: false,
              message: e.response!.toString(),
              responseCode: 400);
        } else {
          return HttpResponse(
              isSuccess: false, message: (e.message), responseCode: 500);
        }
      } else {
        return HttpResponse(
            isSuccess: false, message: e.toString(), responseCode: 500);
      }
    }
  }
}
