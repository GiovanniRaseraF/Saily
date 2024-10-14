// author: Giovanni Rasera
// for now the implementation in fake

import 'dart:convert';

class VTGInfo {
  VTGInfo({required this.isFixed, required this.satellitesCount, required this.SOG, required this.lat, required this.lng});

  int satellitesCount = 0;
  bool isFixed = false;
  double SOG = 0; // usualy in km/hr from NMEA2000
  double lat = 0;
  double lng = 0;

  static VTGInfo? fromJSONDynamic(dynamic json) {
    try {
      int satellitesCount = json["satellitesCount"];
      bool isFixed = json["isFixed"];
      double SOG = json["SOG"]; // usualy in km/hr from NMEA2000
      double lat = json["lat"];
      double lng = json["lng"];

      VTGInfo ret = VTGInfo(isFixed: isFixed, satellitesCount: satellitesCount, SOG: SOG, lat: lat, lng: lng);
      return ret;
    } on Exception {
      return null;
    }
  }

  static VTGInfo? fromJSONString(String json) {
    try {
      final parsed = jsonDecode(json);
      return VTGInfo.fromJSONDynamic(parsed);
    } on Exception {
      return null;
    }
  }

  @override
  String toString() {
    return """{
      'satellitesCount' : $satellitesCount,
      'isFixed' : $isFixed,
      'SOG' : $SOG,
      'lat' : $lat,
      'lng' : $lng,
    }""";
  }
}
