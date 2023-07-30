class LoginResponse {
  String? token;
  String? name;
  int? isEmailVerified;

  LoginResponse({this.token, this.name, this.isEmailVerified});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    name = json['name'];
    isEmailVerified = json['is_email_verified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    data['name'] = name;
    data['is_email_verified'] = isEmailVerified;

    return data;
  }
}
