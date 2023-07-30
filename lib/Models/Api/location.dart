import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ion_application/Utils/extensions.dart';

class LocationModel {
  String? index;
  LatLong? latLng;
  PlugTypes? plugTypes;
  int? amps;
  String? type;
  Facilities? facilities;
  String? name;
  String? nameAr;
  List<Sublocations>? sublocations;
  int? total;
  int? available;
  int? tariff;
  String? tariffType;
  DateTime? startTime;
  BitmapDescriptor? marker;

  LocationModel(
      {this.latLng,
        this.plugTypes,
        this.amps,
        this.type,
        this.facilities,
        this.name,
        this.nameAr,
        this.sublocations,
        this.total,
        this.available,
        this.tariff,
        this.marker,
        this.tariffType,this.startTime,this.index});

  LocationModel.fromJson(Map<String, dynamic> json) {
    latLng = json['latLng'] != null ? LatLong.fromJson(json['latLng']) : null;
    plugTypes = json['plugTypes'] != null
        ? PlugTypes.fromJson(json['plugTypes'])
        : null;
    amps = json['amps'];
    startTime = json['startDate'] !=null
        ? json['startDate']!.toString().getDateFromString()
        : null;
    type = json['type'];
    facilities = json['facilities'] != null
        ? Facilities.fromJson(json['facilities'])
        : null;
    name = json['name'];
    nameAr = json['nameAr'];
    if (json['sublocations'] != null) {
      sublocations = <Sublocations>[];
      json['sublocations'].forEach((v) {
        sublocations!.add(Sublocations.fromJson(v));
      });
    }
    total = json['total'];
    available = json['available'];
    tariff = json['tariff'];
    tariffType = json['tariffType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.latLng != null) {
      data['latLng'] = this.latLng!.toJson();
    }
    if (this.plugTypes != null) {
      data['plugTypes'] = this.plugTypes!.toJson();
    }
    data['amps'] = this.amps;
    data['type'] = this.type;
    if (this.facilities != null) {
      data['facilities'] = this.facilities!.toJson();
    }
    data['name'] = this.name;
    data['nameAr'] = this.nameAr;
    if (this.sublocations != null) {
      data['sublocations'] = this.sublocations!.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    data['available'] = this.available;
    data['tariff'] = this.tariff;
    data['tariffType'] = this.tariffType;
    return data;
  }
}

class LatLong {
  double? latitude;
  double? longitude;

  LatLong({this.latitude, this.longitude});

  LatLong.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}

class PlugTypes {
  bool? j17721;
  bool? j17722;
  bool? cHAdeMO;

  PlugTypes({this.j17721, this.j17722, this.cHAdeMO});

  PlugTypes.fromJson(Map<String, dynamic> json) {
    j17721 = json['J1772-1'];
    j17722 = json['J1772-2'];
    cHAdeMO = json['CHAdeMO'];
  }

  List<String> toJson() {
    final List<String> dataList = [];

    if (j17721 == true) {
      dataList.add('J1772-1');
    }
    if (j17722 == true) {
      dataList.add('J1772-2');
    }
    if (cHAdeMO == true) {
      dataList.add('CHAdeMO');
    }

    return dataList;
  }
}

class Facilities {
  bool? wifi;

  Facilities({this.wifi});

  Facilities.fromJson(Map<String, dynamic> json) {
    wifi = json['wifi'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['wifi'] = this.wifi;
    return data;
  }
}

class Sublocations {
  String? description;
  String? descriptionAr;
  int? available;
  int? total;
  List<dynamic>? img;

  Sublocations(
      {this.description,
        this.descriptionAr,
        this.available,
        this.total,
        this.img});

  Sublocations.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    descriptionAr = json['descriptionAr'];
    available = json['available'];
    total = json['total'];
    img = json['img'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this.description;
    data['descriptionAr'] = this.descriptionAr;
    data['available'] = this.available;
    data['total'] = this.total;
    data['img'] = this.img;
    return data;
  }
}

