class StandardResponse {
  String? message;

  StandardResponse( this.message);

  StandardResponse.fromJson(String json) {
    message =  json;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;

    return data;
  }
}
