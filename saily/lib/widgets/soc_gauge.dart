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

class BatteryGauge extends StatefulWidget {
  BatteryGauge({required this.settingsController, required this.small});

  SettingsController settingsController;
  bool small;
  @override
  State<BatteryGauge> createState() =>
      _BatteryGaugeState(settingsController: settingsController, small: small);
}

class _BatteryGaugeState extends State<BatteryGauge> {
  _BatteryGaugeState({required this.settingsController, required this.small}) {}

  BatteryInfo internalBatteryInfo = BatteryInfo(SOC: 0);
  SettingsController settingsController;
  bool small;

  @override
  Widget build(BuildContext c) {
      return StreamBuilder(
            stream: settingsController.getBatteryInfoStream(),
            builder: (bc, snapshot) {
            // read data
              if (snapshot.data != null) {
                internalBatteryInfo = snapshot.data!;
              }

              return Container(
                child: Column(
                  children: [
                    Text("SOC"),
                    Text("${internalBatteryInfo.SOC} %", style: TextStyle(fontSize: 38),)
                  ],
                ),
              );
            }
      );
  }
}
