import 'package:dio/dio.dart';
import '../Localization/current_language.dart';
import '../Models/Api/current_user.dart';

class ApiClient {
  static const baseUrl = "https://api.evse.cloud/api/v2/";
  static const baseV3Url = "https://api.evse.cloud/api/v3/";

  static Dio getDio({bool useV3 = false}) {
    BaseOptions options = BaseOptions(
        followRedirects: false,
        baseUrl:useV3?baseV3Url: baseUrl,
        responseType: ResponseType.plain,
        connectTimeout: const Duration(seconds: 10),
        headers: {
          "Content-type": "application/json",
          "Accept": "application/json",
          "X-Requested-With": "XMLHttpRequest",
          "Authorization": "Bearer ${CurrentUser.token}",
          "Accept-Language": currentLanguageIsEnglish ? "en" : "ar"
        });

    Dio dio = Dio(options);

    return dio;
  }
}
