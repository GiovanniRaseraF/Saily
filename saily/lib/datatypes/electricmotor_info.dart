// From: Messaggi_CAN_Per_Huracan_Naviop_v1_9
// Author: Giovanni Rasera

import 'dart:convert';

class ElectricmotorInfo {
  double busVoltage = 0.0; // factor 0.1 V
  double motorCurrent = 0.0; // factor 0.1 A
  double inverterTemperature = 0.0; // C
  double motorTemperature = 0.0; // C
  double motorRPM = 0.0; // RPM

  static ElectricmotorInfo? fromJSONDynamic(dynamic json) {
    try {
      ElectricmotorInfo ret = ElectricmotorInfo();
      double busVoltage = (json["busVoltage"] as num).toDouble();
      double motorCurrent = (json["motorCurrent"] as num).toDouble();
      double inverterTemperature = (json["inverterTemperature"] as num).toDouble();
      double motorTemperature = (json["motorTemperature"] as num).toDouble();
      double motorRPM = (json["motorRPM"] as num).toDouble();

      ret.busVoltage = busVoltage;
      ret.motorCurrent = motorCurrent;
      ret.inverterTemperature = inverterTemperature;
      ret.motorTemperature = motorTemperature;
      ret.motorRPM = motorRPM;
      return ret;
    } on Exception {
      return null;
    }
  }

  static ElectricmotorInfo? fromJSONString(String json) {
    try {
      final parsed = jsonDecode(json);
      return ElectricmotorInfo.fromJSONDynamic(parsed);
    } on Exception {
      return null;
    }
  }

  @override
  String toString(){
    String ret = """{
      "busVoltage" : $busVoltage,
      "motorCurrent" : $motorCurrent,
      "inverterTemperature" : $inverterTemperature,
      "motorTemperature" : $motorTemperature,
      "motorRPM" : $motorRPM
    }
    """;
    return jsonEncode(jsonDecode(ret));
  }
}
