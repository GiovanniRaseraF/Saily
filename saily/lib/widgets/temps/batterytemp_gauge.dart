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
import 'package:saily/widgets/temps/batterytemp_gauge.dart';
import 'package:saily/widgets/microdivider_widget.dart';
import 'package:saily/widgets/temps/xtemp_gauge.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class BatteryTempGauge extends StatefulWidget {
  BatteryTempGauge({required this.settingsController, required this.small});

  SettingsController settingsController;
  bool small;
  @override
  State<BatteryTempGauge> createState() => _BatteryTempGaugeState(
      settingsController: settingsController, small: small);
}

class _BatteryTempGaugeState extends State<BatteryTempGauge> {
  _BatteryTempGaugeState(
      {required this.settingsController, required this.small}) {
        unit = settingsController.getMotorTempUnit();
      }

  HighpowerbatteryInfo info = HighpowerbatteryInfo(SOC: 0, auxBatteryVoltage: 0, batteryTemperature: 0, bmsTemperature: 0, power: 0, totalCurrent: 0, totalVoltage: 0, tte: 0);
  SettingsController settingsController;
  bool small = true;
  String unit = "";

  Widget build_(BuildContext c) {
    return StreamBuilder(
        stream: settingsController.getHighPowerBatteryInfoStream(),
        builder: (bc, snapshot) {
          // read data
          if (snapshot.data != null) { info = snapshot.data!;}

          return StreamBuilder(
            stream: settingsController.getMotorTempStream(),
            builder: (c, sn) {
              if (sn.data != null) {
                unit = sn.data!;
              }
              return XTempGauge(settingsController: settingsController, title: "Battery Temperature", unit: unit, startValue: 0, endValue: 150, small: small, value: info.batteryTemperature,);
            },
          );
        });
  }

  @override
  Widget build(BuildContext c) {
    return build_(c);
  }
}
