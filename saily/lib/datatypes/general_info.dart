// From: Messaggi_CAN_Per_Huracan_Naviop_v1_9
// Author: Giovanni Rasera

// Tabella 1
import 'dart:convert';

import 'package:flutter/material.dart';

enum DieselMotorModel { None, MercuryOOD3_0L, HyundaiS270, VolvoPentaD4_D6 }

// Tabella 2
enum ElectricMotorModel {
  None,
  THOR3000,
  THOR6000,
}

// Generale Info
class GeneralInfo {
  GeneralInfo(
      {required this.isHybrid,
      required this.isDualMotor,
      required this.versionProtocol,
      required this.versionFWControlUnit,
      required this.versionFWDrive,
      required this.dieselMotorModel,
      required this.electricMotorModel});

  static GeneralInfo zero() {
    return GeneralInfo(
        isHybrid: false,
        isDualMotor: false,
        versionProtocol: 0,
        versionFWControlUnit: 0,
        versionFWDrive: 0,
        dieselMotorModel: DieselMotorModel.None,
        electricMotorModel: ElectricMotorModel.None);
  }

  bool isHybrid = false; // false = FullElectric , true = Hybrid
  bool isDualMotor = false; // false = SingleMotor, true = DualMotor
  double versionProtocol = 0.0; // factor 0.1
  double versionFWControlUnit = 0.0; // factor 0.01
  double versionFWDrive = 0.0; // factor 0.01
  DieselMotorModel dieselMotorModel = DieselMotorModel.None; // Tabella 1
  ElectricMotorModel electricMotorModel = ElectricMotorModel.None; // Tabella 2

  static GeneralInfo? fromJSONDynamic(dynamic json) {
    try {
      bool isHybrid = json["isHybrid"];
      bool isDualMotor = json["isDualMotor"];
      double versionProtocol = (json["versionProtocol"] as num).toDouble();
      double versionFWControlUnit = (json["versionFWControlUnit"] as num).toDouble();
      double versionFWDrive = (json["versionFWDrive"] as num).toDouble();
      // TODO: implement model parser from json string
      DieselMotorModel dieselMotorModel = DieselMotorModel.None; // Tabella 1
      ElectricMotorModel electricMotorModel =
          ElectricMotorModel.None; // Tabella 2
      GeneralInfo ret = GeneralInfo(
          isHybrid: isHybrid,
          isDualMotor: isDualMotor,
          versionProtocol: versionProtocol,
          versionFWControlUnit: versionFWControlUnit,
          versionFWDrive: versionFWDrive,
          dieselMotorModel: dieselMotorModel,
          electricMotorModel: electricMotorModel);
      return ret;
    } on Exception {
      return null;
    }
  }

  static GeneralInfo? fromJSONString(String json) {
    try {
      final parsed = jsonDecode(json);
      return GeneralInfo.fromJSONDynamic(parsed);
    } on Exception {
      return null;
    }
  }

  @override
  String toString() {
    String ret = """{
          "isHybrid": $isHybrid,
          "isDualMotor": $isDualMotor,
          "versionProtocol": $versionProtocol,
          "versionFWControlUnit": $versionFWControlUnit,
          "versionFWDrive": $versionFWDrive,
          "dieselMotorModel": 0,
          "electricMotorModel":0 
    }
    """;
    return jsonEncode(jsonDecode(ret));
  }
}
