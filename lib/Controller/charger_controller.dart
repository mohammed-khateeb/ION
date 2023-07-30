import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ion_application/Models/Api/location.dart';
import 'package:ion_application/Services/charger_services.dart';

import '../Models/Api/user.dart';
import '../Models/Responses/httpresponse.dart';
import '../Services/auth_services.dart';
import '../Utils/user_utils.dart';

class ChargerController with ChangeNotifier {
  List<LocationModel>? chargersLocations;


  Future<HttpResponse> startCharger(int pin)async{
    final ChargerServices chargerServices = ChargerServices();
    return await chargerServices.startCharger(pin);
  }

  stopCharger(int pin)async{
    final ChargerServices chargerServices = ChargerServices();
    await chargerServices.stopCharger(pin);
  }


  getChargersLocations() async {
    final ChargerServices chargerServices = ChargerServices();
    HttpResponse<List<LocationModel>> response = await chargerServices.getChargerLocations();
    if(response.isSuccess!){
      setChargersLocations(response.data!);
    }
  }

  void setChargersLocations(List<LocationModel> chargersLocations) {
    this.chargersLocations = chargersLocations;
    print(this.chargersLocations!.first.name);
    notifyListeners();
  }
}
