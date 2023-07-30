import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ion_application/Localization/current_language.dart';
import 'package:ion_application/Models/Api/current_user.dart';

import '../Api/api_client.dart';
import '../Models/Api/user.dart' as userApp;
import '../Models/Requests/login_request_body.dart';
import '../Models/Requests/register_request_body.dart';
import '../Models/Responses/error_response.dart';
import '../Models/Responses/httpresponse.dart';
import '../Models/Responses/standard_response.dart';

class AuthServices {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  Dio? _dio;

  AuthServices() {
    _dio = ApiClient.getDio();
  }

  Future<String?> refreshToken() async {
    User? user = FirebaseAuth.instance.currentUser;
    print(user);
    // Make a request to your authentication server or use the appropriate method to refresh the token
      if (user != null) {
        IdTokenResult tokenResult = await user.getIdTokenResult(true);
        return tokenResult.token;
      }

    return null; // Return null if token refresh fails
  }
  Future signOut() async {
    await firebaseAuth.signOut();
  }

  Future<HttpResponse> registerNotificationToken()async{
    try {
      final response = await _dio!.get("/register_notification_token");
      if (response.statusCode == 200) {
        return HttpResponse(
            isSuccess: true,
            responseCode: 200);
      } else {
        StandardResponse standardResponse =
        StandardResponse.fromJson(response.data);
        return HttpResponse(
            isSuccess: false,
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

  Future<HttpResponse<bool>> updateDeviceId(
      { required String token,required String deviceId
      }) async {
    try {
      final response = await _dio!.get("/update_device_id?token=$token&deviceId=$deviceId");
      if (response.statusCode == 200) {
        return HttpResponse(
            isSuccess: true,
            message: response.data,
            responseCode: 200);
      } else {
        StandardResponse standardResponse =
        StandardResponse.fromJson(response.data);
        return HttpResponse(
            isSuccess: false,
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

  Future<HttpResponse<bool>> changeLanguage(
      {required String language,}) async {
    try {
      final response = await _dio!.post("/profile/language?language=$language");
      if (response.statusCode == 200) {
        return HttpResponse(
            isSuccess: true,
            message: response.data,
            responseCode: 200);
      } else {
        StandardResponse standardResponse =
        StandardResponse.fromJson(response.data);
        return HttpResponse(
            isSuccess: false,
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

  Future<HttpResponse<bool>> updateFcmToken(
      { required String token
      }) async {
    try {
      final response = await _dio!.get("/register_notification_token?token=$token");
      if (response.statusCode == 200) {
        return HttpResponse(
            isSuccess: true,
            message: response.data,
            responseCode: 200);
      } else {
        StandardResponse standardResponse =
        StandardResponse.fromJson(response.data);
        return HttpResponse(
            isSuccess: false,
            message: standardResponse.message,
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
          print("----------------${e.response}");
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

  Future<HttpResponse<bool>> checkToken(
      { required String token
      }) async {
    try {
      final response = await _dio!.get("/check_token?token=$token");
      if (response.statusCode == 200) {
        return HttpResponse(
            isSuccess: true,
            responseCode: 200);
      } else {
        StandardResponse standardResponse =
        StandardResponse.fromJson(response.data);
        return HttpResponse(
            isSuccess: false,
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



  Future<HttpResponse<userApp.User>> getProfile() async {
    try {
      final response = await _dio!.get("/profile",);
      if (response.statusCode == 200) {
        userApp.User user = userApp.User.fromJson(json.decode(response.data));
        return HttpResponse(
            isSuccess: true,
            data: user,
            message: "Get Successfully",
            responseCode: 200);
      } else {
        StandardResponse standardResponse =
        StandardResponse.fromJson(response.data);
        return HttpResponse(
            isSuccess: false,
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

  Future<HttpResponse> register(
      { required userApp.User user
      }) async {
    try {
      RegisterRequestBody registerRequestBody = RegisterRequestBody(
          firstName: user.firstName,
          lastName: user.lastName,
          email: user.email,
          token: user.apiToken,
          deviceId: user.deviceId,
          );


      print(registerRequestBody.toStringData());
      final response = await _dio!.get("/register${registerRequestBody.toStringData()}");

      if (response.statusCode == 200) {

        return HttpResponse(
            isSuccess: true,
            message: "Register Successfully",
            responseCode: 200);
      } else {
        StandardResponse standardResponse =
            StandardResponse.fromJson(response.data);
        print(response.data);
        return HttpResponse(
            isSuccess: false,
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
