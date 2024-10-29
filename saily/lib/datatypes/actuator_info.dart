// From: Messaggi_CAN_Per_Huracan_Naviop_v1_9
// Author: Giovanni Rasera

import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

//@JsonSerializable()
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
      int pedal = getInt(json, "pedal");
      int requestedGear = getInt(json, "requestedGear");
      int validatedGear = getInt(json, "validatedGear");
      int pedalTrim = getInt(json, "pedalTrim");

      return ActuatorInfo(
        pedal: pedal,
        requestedGear: requestedGear,
        validatedGear: validatedGear,
        pedalTrim: pedalTrim
      );
    } on Exception catch (err){
      print("${err} Maybe you have to parse json as Saily Authentication Error ${jsonEncode(json)}");
    }
    return null;
  }

  static int getInt(dynamic json, String elem){
    try{
      if(json[elem] == null) throw 0;
      return (json[elem] as int);
    }on int catch(_){
      throw Exception();//"Parse Error";
    }
  }

  static ActuatorInfo? fromJSONString(String json) {
    try {
      final parsed = jsonDecode(json);
      return ActuatorInfo.fromJSONDynamic(parsed);
    } on Exception catch(err){
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
