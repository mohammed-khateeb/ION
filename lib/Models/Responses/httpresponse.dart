class HttpResponse<T> {
  bool? isSuccess;
  T? data;
  String? message;
  int? responseCode;

  HttpResponse({this.isSuccess, this.data, this.message, this.responseCode});
}
