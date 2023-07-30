import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:ion_application/Models/Api/location.dart';
import 'package:ion_application/Models/Api/transactions.dart';

import '../Api/api_client.dart';
import '../Models/Api/user.dart';
import '../Models/Requests/login_request_body.dart';
import '../Models/Requests/register_request_body.dart';
import '../Models/Responses/error_login_response.dart';
import '../Models/Responses/error_response.dart';
import '../Models/Responses/httpresponse.dart';
import '../Models/Responses/standard_response.dart';

class TransactionsServices {
  Dio? _dio;

  TransactionsServices({bool useV3 = false}) {
    _dio = ApiClient.getDio(useV3: useV3);
  }

  Future<HttpResponse<List<Transaction>>> getTransactions() async {
    try {
      final response = await _dio!.get(
        "transactions",
      );
      if (response.statusCode == 200) {
        print(jsonDecode(response.data));
        List<Transaction> transactions = [];
        jsonDecode(response.data).forEach((v) {
          transactions.add(Transaction.fromJson(v));
        });
        return HttpResponse(
            isSuccess: true,
            data: transactions,
            message: "Get Successfully",
            responseCode: 200);
      } else {
        String error = response.toString();

        return HttpResponse(
            isSuccess: false, message: error, responseCode: 400);
      }
    } catch (e) {
      print(e);
      if (e is DioError) {
        if (e.message != null && e.message!.contains("SocketException")) {
          return HttpResponse(
              isSuccess: false,
              message: "Connection Failed",
              responseCode: 500);
        } else if (e.response != null) {
          String error = e.response!.toString();
          return HttpResponse(
              isSuccess: false, message: error, responseCode: 400);
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

  Future<HttpResponse<List<int>>> getSessionActive() async {
    try {
      final response = await _dio!.get(
        "charger/session_active",
      );
      if (response.statusCode == 200) {
        List<dynamic> responseList = jsonDecode(response.data);
        List<int>? sessionActive;
        if (responseList.isNotEmpty) {
          sessionActive =
              responseList.map<int>((item) => item["session_id"]).toList();
        }

        return HttpResponse(
            isSuccess: true,
            data: sessionActive??[],
            message: "Get Successfully",
            responseCode: 200);
      } else {
        String error = response.toString();

        return HttpResponse(
            isSuccess: false, message: error, data: [], responseCode: 400);
      }
    } catch (e) {
      print(e);
      print("------------------");
      if (e is DioError) {
        if (e.message != null && e.message!.contains("SocketException")) {
          return HttpResponse(
              isSuccess: false,
              data: [],
              message: "Connection Failed",
              responseCode: 500);
        } else if (e.response != null) {
          String error = e.response!.toString();
          return HttpResponse(
              isSuccess: false, message: error, data: [], responseCode: 400);
        } else {
          return HttpResponse(
            isSuccess: false,
            message: (e.message),
            responseCode: 500,
            data: [],
          );
        }
      } else {
        return HttpResponse(
          isSuccess: false,
          message: e.toString(),
          responseCode: 500,
          data: [],
        );
      }
    }
  }
}
