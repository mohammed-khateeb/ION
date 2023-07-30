class ErrorLoginResponse {
  int? status;
  Errors? errors;

  ErrorLoginResponse({this.status, this.errors});

  ErrorLoginResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    errors =
    json['errors'] != null ? Errors.fromJson(json['errors']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (errors != null) {
      data['errors'] = errors!.toJson();
    }
    return data;
  }
}

class Errors {

  List<String>? email;
  List<String>? password;


  Errors(
      {
        this.email,
        this.password,
      });

  Errors.fromJson(Map<String, dynamic> json) {

    email = json['email']!=null?json['email'].cast<String>():null;
    password = json['password']!=null?json['password'].cast<String>():null;

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['email'] = email;
    data['password'] = password;

    return data;
  }
}