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

class MotorTempGauge extends StatefulWidget {
  MotorTempGauge({required this.settingsController, required this.small});

  SettingsController settingsController;
  bool small;
  @override
  State<MotorTempGauge> createState() =>
      _MotorTempGaugeState(settingsController: settingsController, small: small);
}

class _MotorTempGaugeState extends State<MotorTempGauge> {
  _MotorTempGaugeState({required this.settingsController, required this.small}) {}

  BatteryInfo internalBatteryInfo = BatteryInfo(SOC: 0);
  SettingsController settingsController;
  bool small = true;
  String unit = "";

  Widget buildSmall(BuildContext c) {
    return StreamBuilder(
        stream: settingsController.getBatteryInfoStream(),
        builder: (bc, snapshot) {
          String spacer = "";
          // read data
          if (snapshot.data != null) {
            internalBatteryInfo = snapshot.data!;
            if(internalBatteryInfo.temp < 10) spacer = "0";
          }

          return Container(
            child: Column(
              children: [
                Row(children: [Text("Motor Temp: "), StreamBuilder(stream: settingsController.getMotorTempStream(), builder: (c, sn){
                  if(sn.data != null){
                    unit = sn.data!;
                  }
                  return Text(unit);
                },)]),
                Text(
                  "${spacer}${internalBatteryInfo.temp.toStringAsFixed(1)}",
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
            if(internalBatteryInfo.temp < 10) spacer = "0";
        }

          return Container(
            child: Column(
              children: [
                Row(children: [Text("Motor Temp: "), StreamBuilder(stream: settingsController.getMotorTempStream(), builder: (c, sn){
                  if(sn.data != null){
                    unit = sn.data!;
                  }
                  return Text(unit);
                },)]),
                Text(
                  "${spacer}${internalBatteryInfo.temp.toStringAsFixed(1)}",
                  style: TextStyle(fontSize: 38),
                )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext c) {
    unit = settingsController.getMotorTempUnit();
    if (small) {
      return buildSmall(c);
    } else {
      return buildBig(c);
    }
  }
}
