import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:ion_application/Models/Api/location.dart';

import '../Api/api_client.dart';
import '../Models/Responses/httpresponse.dart';

class ChargerServices {
  Dio? _dio;

  ChargerServices() {
    _dio = ApiClient.getDio();
  }


  Future<HttpResponse<List<LocationModel>>> getChargerLocations() async {
    try {
      final response = await _dio!.get("charger_locations",);
      if (response.statusCode == 200) {
        List<LocationModel> locations =[];
        jsonDecode(response.data).forEach((v) {
          locations.add(LocationModel.fromJson(v));
        });
        return HttpResponse(
            isSuccess: true,
            data: locations,
            message: "Get Successfully",
            responseCode: 200);
      } else {
        String error =
        response.toString();

        return HttpResponse(
            isSuccess: false,
            message: error,
            responseCode: 400);
      }
    } catch (e) {
      print(e);
      if (e is DioError) {
        if (e.message!=null&&e.message!.contains("SocketException")) {
          return HttpResponse(
              isSuccess: false,
              message: "Connection Failed",
              responseCode: 500);
        } else if (e.response != null) {
          String error =
          e.response!.toString();
          return HttpResponse(
              isSuccess: false,
              message: error,
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

  Future<HttpResponse> startCharger(int pin) async {
    try {
      final response = await _dio!.get("charger/start?pin=$pin",);
      if (response.statusCode == 200) {
        return HttpResponse(
            isSuccess: true,
            message: response.toString(),
            responseCode: 200);
      } else {
        return HttpResponse(
            isSuccess: false,
            message: response.toString(),
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
          String error =
          e.response!.toString();
          return HttpResponse(
              isSuccess: false,
              message: error,
              responseCode: e.response!.statusCode);
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

  Future<HttpResponse> stopCharger(int pin) async {
    try {
      final response = await _dio!.get("charger/stop?pin=$pin",);
      if (response.statusCode == 200) {
        return HttpResponse(
            isSuccess: true,
            message: response.toString(),
            responseCode: 200);
      } else {
        return HttpResponse(
            isSuccess: false,
            message: response.toString(),
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
          String error =
          e.response!.toString();
          return HttpResponse(
              isSuccess: false,
              message: error,
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
