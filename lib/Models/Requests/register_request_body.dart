

class RegisterRequestBody {
  String? firstName;
  String? lastName;
  String? email;
  String? token;
  String? deviceId;


      RegisterRequestBody(
      {this.firstName,
      this.lastName,
        this.token,
      this.email,
      this.deviceId,
      });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fname'] = firstName;
    data['lname'] = lastName;
    data['email'] = email;
    data['token'] = token;
    data['deviceId'] = deviceId;
    return data;
  }

  String toStringData(){
    return "?fname=$firstName&lname=$lastName&email=$email&token=$token&deviceId=$deviceId";
  }
}
