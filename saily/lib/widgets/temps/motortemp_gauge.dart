/*
author: Giovanni Rasera
*/

import 'dart:async';
import 'dart:convert';

import 'package:cupertino_battery_indicator/cupertino_battery_indicator.dart';
import 'package:flutter/material.dart';
import 'package:saily/datatypes/electricmotor_info.dart';
import 'package:saily/datatypes/highpowerbattery_info.dart';
import 'package:saily/settings/settings_controller.dart';
import 'package:saily/utils/saily_colors.dart';
import 'package:saily/widgets/microdivider_widget.dart';
import 'package:saily/widgets/temps/xtemp_gauge.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class MotorTempGauge extends StatefulWidget {
  MotorTempGauge({required this.settingsController, required this.small});

  SettingsController settingsController;
  bool small;
  @override
  State<MotorTempGauge> createState() => _MotorTempGaugeState(
      settingsController: settingsController, small: small);
}

class _MotorTempGaugeState extends State<MotorTempGauge> {
  _MotorTempGaugeState(
      {required this.settingsController, required this.small}) {
        unit = settingsController.getMotorTempUnit();
      }

  ElectricmotorInfo info = ElectricmotorInfo();
  SettingsController settingsController;
  bool small = true;
  String unit = "";

   Widget build_(BuildContext c) {
    return StreamBuilder(
        stream: settingsController.getElectricMotorInfoStream(),
        builder: (bc, snapshot) {
          // read data
          if (snapshot.data != null) { info = snapshot.data!;}

          return StreamBuilder(
            stream: settingsController.getMotorTempStream(),
            builder: (c, sn) {
              if (sn.data != null) {
                unit = sn.data!;
              }
              return XTempGauge(settingsController: settingsController, title: "Motor Temperature", unit: unit, startValue: 0, endValue: 150, small: small, value: info.motorTemperature,);
            },
          );
        });
  }

  @override
  Widget build(BuildContext c) {
    return build_(c);
  }
}
