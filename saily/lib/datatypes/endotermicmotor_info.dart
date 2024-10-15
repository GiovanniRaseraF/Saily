// From: Messaggi_CAN_Per_Huracan_Naviop_v1_9
// Author: Giovanni Rasera

import 'dart:convert';

enum GlowStatus { OFF, ON }

enum DieselStatus {
  WAIT, // 0
  WAIT_CRANKING, // 10
  RUNNING, // 50
  FAULT // 110
}

class EndotermicmotorInfo {
  int motorRPM = 0; // RPM
  double refrigerationTemperature = 0.0; // C
  double batteryVoltage = 0.0; // factor 0.1 V
  int throttlePedalPosition = 0; // %
  GlowStatus glowStatus = GlowStatus.OFF;
  DieselStatus dieselStatus = DieselStatus.WAIT;
  int fuelLevel1 = 0; // %
  int fuelLevel2 = 0; // %

  static EndotermicmotorInfo? fromJSONDynamic(dynamic json) {
    try {
      EndotermicmotorInfo ret = EndotermicmotorInfo();

      int motorRPM = (json["motorRPM"] as num).toInt(); // RPM
      double refrigerationTemperature = (json["refrigerationTemperature"] as num).toDouble(); // C
      double batteryVoltage = (json["batteryVoltage"] as num).toDouble(); // factor 0.1 V
      int throttlePedalPosition = (json["throttlePedalPosition"] as num).toInt(); // %
      // TODO: fix conversion from GlowStatus to something JSON supports
      GlowStatus glowStatus = GlowStatus.OFF; //json["glowStatus"];
      DieselStatus dieselStatus = DieselStatus.WAIT; //json["dieselStatus"];
      int fuelLevel1 = (json["fuelLevel1"] as num).toInt(); // %
      int fuelLevel2 = (json["fuelLevel2"] as num).toInt();  // %

      ret.motorRPM = motorRPM;
      ret.refrigerationTemperature = refrigerationTemperature;
      ret.batteryVoltage = batteryVoltage;
      ret.throttlePedalPosition = throttlePedalPosition;
      ret.glowStatus = glowStatus;
      ret.dieselStatus = dieselStatus;
      ret.fuelLevel1 = fuelLevel1;
      ret.fuelLevel2 = fuelLevel2;

      return ret;
    } on Exception {
      return null;
    }
  }

  static EndotermicmotorInfo? fromJSONString(String json) {
    try {
      final parsed = jsonDecode(json);
      return EndotermicmotorInfo.fromJSONDynamic(parsed);
    } on Exception {
      return null;
    }
  }

  @override
  String toString() {
    String ret = """{
      "motorRPM" : $motorRPM,
      "refrigerationTemperature" : $refrigerationTemperature,
      "batteryVoltage" : $batteryVoltage,
      "throttlePedalPosition" : $throttlePedalPosition,
      "glowStatus" : 0,
      "dieselStatus" : 0,
      "fuelLevel1" : $fuelLevel1,
      "fuelLevel2" : $fuelLevel2
    }
    """;
    return jsonEncode(jsonDecode(ret));
  }
}
