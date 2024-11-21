/*
author: Giovanni Rasera
*/

import 'dart:async';
import 'dart:convert';

import 'package:cupertino_battery_indicator/cupertino_battery_indicator.dart';
import 'package:flutter/material.dart';
import 'package:saily/datatypes/endotermicmotor_info.dart';
import 'package:saily/datatypes/highpowerbattery_info.dart';
import 'package:saily/settings/settings_controller.dart';
import 'package:saily/utils/saily_colors.dart';
import 'package:saily/widgets/microdivider_widget.dart';

class FuelGauge extends StatefulWidget {
  FuelGauge({required this.settingsController, required this.small});

  SettingsController settingsController;
  bool small;
  @override
  State<FuelGauge> createState() =>
      _FuelGaugeState(settingsController: settingsController, small: small);
}

class _FuelGaugeState extends State<FuelGauge> {
  _FuelGaugeState({required this.settingsController, required this.small}) {}

  EndotermicmotorInfo internalBatteryInfo  = EndotermicmotorInfo();
  SettingsController settingsController;
  bool small = true;

  Widget buildSmall(BuildContext c) {
    return StreamBuilder(
        stream: settingsController.getEndotermicMotorInfoStream(),
        builder: (bc, snapshot) {
          String spacer = "";
          // read data
          if (snapshot.data != null) {
            internalBatteryInfo = snapshot.data!;
            if(internalBatteryInfo.fuelLevel1 < 10) spacer = "0";
          }

          return Container(
            child: Column(
              children: [
                Row(children: [Icon(Icons.oil_barrel, color: SailyBlack), Text("Fuel")] ),
                Text(
                  "${spacer}${internalBatteryInfo.fuelLevel1} %",
                  style: TextStyle(fontSize: 25),
                )
              ],
            ),
          );
        });
  }

  Widget buildBig(BuildContext c) {
    return StreamBuilder(
        stream: settingsController.getEndotermicMotorInfoStream(),
        builder: (bc, snapshot) {
          String spacer = "";
          // read data
          if (snapshot.data != null) {
            internalBatteryInfo = snapshot.data!;
        }

          return FittedBox(
            child: Container(
            padding: EdgeInsets.all(10),
            width: 100,
            height: 100,
              child: Column(
                children: [
                  Center(child: Row(children: [Icon(Icons.oil_barrel, color: SailyBlack), Text("Fuel")] , mainAxisAlignment: MainAxisAlignment.spaceAround,)),
                  FittedBox(child: Text(
                    "${spacer}${internalBatteryInfo.fuelLevel1.toStringAsFixed(1)} %",
                    style: TextStyle(fontSize: 38),
                  ))
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
