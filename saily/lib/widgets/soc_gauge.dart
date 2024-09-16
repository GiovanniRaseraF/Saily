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
import 'package:saily/widgets/microdivider_widget.dart';
import 'package:saily/widgets/sog_gauge.dart';
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

  HighpowerbatteryInfo highpowerbatteryInfo = HighpowerbatteryInfo();

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

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  SOGGauge(settingsController: settingsController, small: small)
                ],
              ),
              Column(
                children: [
                  Divider(
                    color: Colors.transparent,
                  ),
                  Text("SOC",
                      style: TextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.bold)),
                  Text("${spacer}${highpowerbatteryInfo.SOC} %",
                      style: TextStyle(fontSize: 25)),
                  AnimatedBatteryGauge(
                    drawBarForExtraValue: true,
                    duration: Duration(seconds: 1),
                    value: highpowerbatteryInfo.SOC,
                    size: Size(40, 30),
                    borderColor: CupertinoColors.systemGrey,
                    valueColor: colorFromValue(highpowerbatteryInfo.SOC),
                    mode: BatteryGaugePaintMode.gauge,
                    hasText: false,
                    textStyle: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Divider(
                    color: Colors.transparent,
                  )
                ],
              ),
            ],
          );
        });
  }

  Color colorFromValue(double SOC) {
    if (SOC > 0 && SOC < 30) return Colors.redAccent;
    if (SOC > 30 && SOC < 50) return SailyOrange;
    return SailyBlue;
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
