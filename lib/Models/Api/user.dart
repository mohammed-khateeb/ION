class User {
  String? firstName;
  String? lastName;
  String? mobileNumber;
  String? email;
  String? apiToken;
  String? fcmToken;
  String? deviceId;
  num? balance;
  bool? belowMinimumBalance;
  bool? lowBalance;

  User(
      {
      this.firstName,
      this.deviceId,
      this.fcmToken,
      this.lastName,this.mobileNumber,this.email,this.apiToken,
        this.balance,this.belowMinimumBalance,this.lowBalance
      });

  User.fromJson(Map<String, dynamic> json) {
    apiToken = json['api_token'];
    firstName = json['first_name'];
    fcmToken = json['fcm_token'];
    lastName = json['last_name'];
    email = json['email'];
    deviceId = json['deviceId'];
    mobileNumber = json['mobile'];
    balance = num.parse(json['balance'].toString());
    belowMinimumBalance = json['belowMinimumBalance'];
    lowBalance = json['lowBalance'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['api_token'] = apiToken;
    data['first_name'] = firstName;
    data['fcm_token'] = fcmToken;
    data['last_name'] = lastName;
    data['email'] = email;
    data['mobile_number'] = mobileNumber;
    data['deviceId'] = deviceId;
    data['balance'] = balance;
    data['belowMinimumBalance'] = belowMinimumBalance;
    data['lowBalance'] = lowBalance;

    return data;
  }
}

