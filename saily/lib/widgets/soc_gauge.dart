/*
author: Giovanni Rasera
*/

import 'dart:async';
import 'dart:convert';

import 'package:cupertino_battery_indicator/cupertino_battery_indicator.dart';
import 'package:flutter/material.dart';
import 'package:saily/datatypes/battery_info.dart';
import 'package:saily/settings/settings_controller.dart';
import 'package:saily/widgets/microdivider_widget.dart';
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

  BatteryInfo internalBatteryInfo = BatteryInfo(SOC: 0);
  SettingsController settingsController;
  bool small = true;

  Widget buildSmall(BuildContext c) {
    return StreamBuilder(
        stream: settingsController.getBatteryInfoStream(),
        builder: (bc, snapshot) {
          String spacer = "";
          // read data
          if (snapshot.data != null) {
            internalBatteryInfo = snapshot.data!;
            if (internalBatteryInfo.SOC < 10) spacer = "0";
          }

          return Container(
            child: Column(
              children: [
                Text("SOC"),
                Text(
                  "${spacer}${internalBatteryInfo.SOC} %",
                  style: TextStyle(fontSize: 25),
                )
              ],
            ),
          );
        });
  }

  Widget buildBig(BuildContext c) {
    return StreamBuilder(
        stream: settingsController.getBatteryInfoStream(),
        builder: (bc, snapshot) {
          String spacer = "";
          // read data
          if (snapshot.data != null) {
            internalBatteryInfo = snapshot.data!;
            if (internalBatteryInfo.SOC < 10) spacer = "0";
          }

          return Container(
            child: Column(
              children: [
                Text("SOC"),
                Text(
                  "${spacer}${internalBatteryInfo.SOC} %",
                  style: TextStyle(fontSize: 38),
                )
              ],
            ),
          );
        });
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
