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

class PowerGauge extends StatefulWidget {
  PowerGauge({required this.settingsController, required this.small});

  SettingsController settingsController;
  bool small;
  @override
  State<PowerGauge> createState() =>
      _PowerGaugeState(settingsController: settingsController, small: small);
}

class _PowerGaugeState extends State<PowerGauge> {
  _PowerGaugeState({required this.settingsController, required this.small}) {}

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
          }

          return Container(
            child: Column(
              children: [
                Text("Power: kW"),
                Text(
                  "${spacer}${internalBatteryInfo.power.toStringAsFixed(1)}",
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
        }

          return Container(
            child: Column(
              children: [
                Text("Power:kW"),
                Text(
                  "${spacer}${internalBatteryInfo.power.toStringAsFixed(1)}",
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
