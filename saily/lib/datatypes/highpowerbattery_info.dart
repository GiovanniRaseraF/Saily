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

  static HighpowerbatteryInfo zero() {
    return HighpowerbatteryInfo(
        totalVoltage: 0,
        totalCurrent: 0,
        batteryTemperature: 0,
        bmsTemperature: 0,
        SOC: 0,
        power: 0,
        tte: 0,
        auxBatteryVoltage: 0);
  }

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
      double totalVoltage = (json["totalVoltage"] as num).toDouble();
      double totalCurrent = (json["totalCurrent"] as num).toDouble();
      double batteryTemperature = (json["batteryTemperature"] as num).toDouble();
      double bmsTemperature = (json["bmsTemperature"] as num).toDouble();
      double SOC = (json["SOC"] as num).toDouble();

      double power = (json["power"] as num).toDouble();
      int tte = (json["tte"] as num).toInt();
      double auxBatteryVoltage = (json["auxBatteryVoltage"] as num).toDouble();

      return HighpowerbatteryInfo(
          totalVoltage: totalVoltage,
          totalCurrent: totalCurrent,
          batteryTemperature: batteryTemperature,
          bmsTemperature: bmsTemperature,
          SOC: SOC,
          power: power,
          tte: tte,
          auxBatteryVoltage: auxBatteryVoltage);
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

  @override
  String toString() {
    String ret = """{
      "totalVoltage": $totalVoltage,
      "totalCurrent": $totalCurrent,
      "batteryTemperature": $batteryTemperature,
      "bmsTemperature": $bmsTemperature,
      "SOC": $SOC,
      "power": $power,
      "tte": $tte,
      "auxBatteryVoltage": $auxBatteryVoltage
    }
    """;
    return jsonEncode(jsonDecode(ret));
  }
}
