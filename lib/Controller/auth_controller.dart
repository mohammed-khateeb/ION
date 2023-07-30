import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../Models/Api/user.dart';
import '../Models/Responses/httpresponse.dart';
import '../Services/auth_services.dart';
import '../Utils/user_utils.dart';

class AuthController with ChangeNotifier {
  User? user;

  bool waiting = true;
  Position? userPosition;



  setUserPosition(Position userPosition){
    this.userPosition = userPosition;
    notifyListeners();
  }

  Future refreshToken() async {
    return await AuthServices().refreshToken();
  }


  Future signOut() async {
    AuthServices authServices = AuthServices();
    await authServices.signOut();
    UserUtils.signOut();
    user = null;
    notifyListeners();
  }


  login({required User user}) async {

    setUserInformation(user);

    await UserUtils.initCurrentUser(user);

  }

  Future<HttpResponse> getProfile()async{
    AuthServices authServices = AuthServices();
    HttpResponse response = await authServices.getProfile();
    if(response.isSuccess==true){
      login(user: response.data);
    }
    return response;
  }

  Future<HttpResponse> updateFcmToken(String token) async {
    AuthServices authServices = AuthServices();

    HttpResponse response = await authServices.updateFcmToken(token: token);
    return response;
  }



  Future<HttpResponse> register({
  required User user
      }) async {
    AuthServices authServices = AuthServices();

    HttpResponse response = await authServices.register(
      user: user
        );
    if(response.isSuccess==true){
      login(user: user);
    }

    return response;
  }



  Future<bool> checkToken(String token) async {
    AuthServices authServices = AuthServices();

    HttpResponse response = await authServices.checkToken(token: token);
    return response.isSuccess == true;
  }


  Future<HttpResponse> updateDeviceId(String token,String deviceId) async {
    AuthServices authServices = AuthServices();

    HttpResponse response = await authServices.updateDeviceId(token: token,deviceId: deviceId);
    return response;
  }

  Future<HttpResponse> changeLanguage(String language) async {
    AuthServices authServices = AuthServices();

    HttpResponse response = await authServices.changeLanguage(language: language);
    return response;
  }




  void setUserInformation(User? user) {
    this.user = user;
    waiting = false;
    notifyListeners();
  }

}
