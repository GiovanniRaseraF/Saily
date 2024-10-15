// From: Messaggi_CAN_Per_Huracan_Naviop_v1_9
// Author: Giovanni Rasera

import 'dart:convert';

class ActuatorInfo {
  ActuatorInfo(
      {this.pedal = 0,
      this.requestedGear = 0,
      this.validatedGear = 0,
      this.pedalTrim = 0});
  int pedal = 0; // %
  int requestedGear = 0;
  int validatedGear = 0;
  int pedalTrim = 0;

  static ActuatorInfo? fromJSONDynamic(dynamic json) {
    try {
      int pedal = json["pedal"];
      int requestedGear = json["requestedGear"];
      int validatedGear = json["validatedGear"];
      int pedalTrim = json["pedalTrim"];

      return ActuatorInfo(
          pedal: pedal,
          requestedGear: requestedGear,
          validatedGear: validatedGear,
          pedalTrim: pedalTrim);
    } on Exception {
      return null;
    }
  }

  static ActuatorInfo? fromJSONString(String json) {
    try {
      final parsed = jsonDecode(json);
      return ActuatorInfo.fromJSONDynamic(parsed);
    } on Exception {
      return null;
    }
  }

  @override
  String toString(){
    String ret = """{
      "pedal": $pedal,
      "requestedGear": $requestedGear,
      "validatedGear": $validatedGear,
      "pedalTrim": $pedalTrim
      }
    """;
    return jsonEncode(jsonDecode(ret));
  }
}
