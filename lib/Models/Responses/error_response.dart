class ErrorResponse {
  late int status;
  late String error;

  ErrorResponse(this.status, this.error);

  ErrorResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['status'] = status;
    data['error'] = error;
    return data;
  }
}