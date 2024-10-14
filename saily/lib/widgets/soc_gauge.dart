/*
author: Giovanni Rasera
*/

import 'dart:async';
import 'dart:convert';

import 'package:animated_battery_gauge/animated_battery_gauge.dart';
import 'package:animated_battery_gauge/battery_gauge.dart';
import 'package:cupertino_battery_indicator/cupertino_battery_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:saily/datatypes/highpowerbattery_info.dart';
import 'package:saily/settings/settings_controller.dart';
import 'package:saily/utils/saily_colors.dart';
import 'package:saily/utils/saily_utils.dart';
import 'package:saily/widgets/microdivider_widget.dart';
import 'package:saily/widgets/main_gauge.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class SOCGauge extends StatefulWidget {
  SOCGauge({required this.settingsController, required this.small});

  SettingsController settingsController;
  bool small;
  @override
  State<SOCGauge> createState() =>
      _SOCGaugeState(settingsController: settingsController, small: small);
}

class _SOCGaugeState extends State<SOCGauge> {
  _SOCGaugeState({required this.settingsController, required this.small}) {}

  HighpowerbatteryInfo highpowerbatteryInfo = HighpowerbatteryInfo(SOC: 0, auxBatteryVoltage: 0, batteryTemperature: 0, bmsTemperature: 0, power: 0, totalCurrent: 0, totalVoltage: 0, tte: 0);

  SettingsController settingsController;
  bool small = true;

  Widget buildSmall(BuildContext c) {
    return StreamBuilder(
        stream: settingsController.getHighPowerBatteryInfoStream(),
        builder: (bc, snapshot) {
          // read data
          if (snapshot.data != null) highpowerbatteryInfo = snapshot.data!;

          return Container(
            child: Column(
              children: [
                Text("SOC"),
                Text(
                  "${highpowerbatteryInfo.SOC} %",
                  style: TextStyle(fontSize: 25),
                )
              ],
            ),
          );
        });
  }

  Widget buildBig(BuildContext c) {
    return StreamBuilder(
        stream: settingsController.getHighPowerBatteryInfoStream(),
        builder: (bc, snapshot) {
          String spacer = "";
          // read data
          if (snapshot.data != null) highpowerbatteryInfo = snapshot.data!;

          return 
              SizedBox(
                child: Column(
                  children: [
                    Text("${spacer}${highpowerbatteryInfo.SOC.toStringAsFixed(0)} %", style: TextStyle(
                      color: SailyBlack,
                      fontSize: 20, fontWeight: FontWeight.bold)),
                    AnimatedBatteryGauge(
                      drawBarForExtraValue: true,
                      duration: Duration(seconds: 1),
                      value: highpowerbatteryInfo.SOC,
                      size: Size(60, 30),
                      borderColor: SailyBlack,
                      valueColor: colorFromValue(highpowerbatteryInfo.SOC),
                      mode: BatteryGaugePaintMode.gauge,
                      hasText: false,
                      textStyle: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
        });
  }

  Color colorFromValue(double SOC) {
    if (SOC > 0 && SOC < 30) return SailySuperRed;
    if (SOC >= 30 && SOC <= 100) return SailySuperGreen;
    return SailySuperGreen;
  }

  @override
  Widget build(BuildContext c) {
    if (small) {
      return buildSmall(c);
    } else {
      return buildBig(c);
    }
  }
}
