// From: Messaggi_CAN_Per_Huracan_Naviop_v1_9
// Author: Giovanni Rasera

import 'dart:convert';

class HighpowerbatteryInfo {
  HighpowerbatteryInfo({
    required this.totalVoltage,
    required this.totalCurrent,
    required this.batteryTemperature,
    required this.bmsTemperature,
    required this.SOC,
    required this.power,
    required this.tte,
    required this.auxBatteryVoltage,
  });

  double totalVoltage = 0.0; // factor 0.1 V
  double totalCurrent = 0.0; // factor 0.1 A
  double batteryTemperature = 0.0; // C
  double bmsTemperature = 0.0; // C
  double SOC = 0.0; // %

  double power = 0.0; // factor 0.1 KW +consumata -assorbita
  int tte = 0; // min
  double auxBatteryVoltage = 0.0; // factor 0.1 V

  static HighpowerbatteryInfo? fromJSONDynamic(dynamic json) {
    try {
      double totalVoltage = json["totalVoltage"];
      double totalCurrent = json["totalCurrent"];
      double batteryTemperature = json["batteryTemperature"]; 
      double bmsTemperature = json["bmsTemperature"]; 
      double SOC = json["SOC"]; 

      double power = json["power"];
      int tte = json["tte"];
      double auxBatteryVoltage = json["auxBatteryVoltage"]; 

      return HighpowerbatteryInfo(totalVoltage: totalVoltage, totalCurrent: totalCurrent, batteryTemperature: batteryTemperature, bmsTemperature: bmsTemperature, SOC: SOC, power: power, tte: tte, auxBatteryVoltage: auxBatteryVoltage);
    } on Exception {
      return null;
    }
  }

  static HighpowerbatteryInfo? fromJSONString(String json) {
    try {
      final parsed = jsonDecode(json);
      return HighpowerbatteryInfo.fromJSONDynamic(parsed);
    } on Exception {
      return null;
    }
  }
}
