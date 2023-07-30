class LoginRequestBody {
  String mobileNumber;
  String password;
  String? fcmToken;

  LoginRequestBody(
      {required this.mobileNumber, required this.password,this.fcmToken});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mobile_number'] = mobileNumber;
    data['password'] = password;
    data['fcm_token'] = fcmToken;

    return data;
  }
}
