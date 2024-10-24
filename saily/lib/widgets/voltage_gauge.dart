/*
author: Giovanni Rasera
*/

import 'dart:async';
import 'dart:convert';

import 'package:cupertino_battery_indicator/cupertino_battery_indicator.dart';
import 'package:flutter/material.dart';
import 'package:saily/datatypes/highpowerbattery_info.dart';
import 'package:saily/settings/settings_controller.dart';
import 'package:saily/utils/saily_colors.dart';
import 'package:saily/utils/utils.dart';
import 'package:saily/widgets/microdivider_widget.dart';

class VoltageGauge extends StatefulWidget {
  VoltageGauge({required this.settingsController, required this.small});

  SettingsController settingsController;
  bool small;
  @override
  State<VoltageGauge> createState() =>
      _VoltageGaugeState(settingsController: settingsController, small: small);
}

class _VoltageGaugeState extends State<VoltageGauge> {
  _VoltageGaugeState({required this.settingsController, required this.small}) {}

  HighpowerbatteryInfo internalBatteryInfo= HighpowerbatteryInfo(SOC: 0, auxBatteryVoltage: 0, batteryTemperature: 0, bmsTemperature: 0, power: 0, totalCurrent: 0, totalVoltage: 0, tte: 0);
  SettingsController settingsController;
  bool small = true;

  Widget buildSmall(BuildContext c) {
    return StreamBuilder(
        stream: settingsController.getHighPowerBatteryInfoStream(),
        builder: (bc, snapshot) {
          String spacer = "";
          // read data
          if (snapshot.data != null) {
            internalBatteryInfo = snapshot.data!;
            if(internalBatteryInfo.totalVoltage < 10) spacer = "0";
          }

          return Container(
            child: Column(
              children: [
                Text("Voltage"),
                Text(
                  "${spacer}${internalBatteryInfo.totalVoltage.toStringAsFixed(1)}",
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
          if (snapshot.data != null) {
            internalBatteryInfo = snapshot.data!;
        }

          return Container(
            padding: EdgeInsets.all(10),
            width: 100,
            height: 80,
            child: FittedBox(
              child: Column(
                children: [
                  Row(children: [Icon(Icons.power, color: SailyLightOrange), Text("Voltage")] ),
                  FittedBox(child: Text(
                    "${internalBatteryInfo.totalVoltage.toStringAsFixed(1)}",
                    style: TextStyle(fontSize: 38),)
                  )
                ],
              ),
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
