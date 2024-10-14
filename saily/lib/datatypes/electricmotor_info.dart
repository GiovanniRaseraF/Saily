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
      double busVoltage = json["busVoltage"];
      double motorCurrent = json["motorCurrent"];
      double inverterTemperature = json["inverterTemperature"];
      double motorTemperature = json["motorTemperature"];
      double motorRPM = json["motorRPM"];

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
}
