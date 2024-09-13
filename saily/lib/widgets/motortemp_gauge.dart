/*
author: Giovanni Rasera
*/

import 'dart:async';
import 'dart:convert';

import 'package:cupertino_battery_indicator/cupertino_battery_indicator.dart';
import 'package:flutter/material.dart';
import 'package:saily/datatypes/battery_info.dart';
import 'package:saily/settings/settings_controller.dart';
import 'package:saily/utils/saily_colors.dart';
import 'package:saily/widgets/microdivider_widget.dart';
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
      {required this.settingsController, required this.small}) {}

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
            if (internalBatteryInfo.temp < 10) spacer = "0";
          }

          return Container(
            child: Column(
              children: [
                Row(children: [
                  Text("Motor Temp: "),
                  StreamBuilder(
                    stream: settingsController.getMotorTempStream(),
                    builder: (c, sn) {
                      if (sn.data != null) {
                        unit = sn.data!;
                      }
                      return Text(unit);
                    },
                  )
                ]),
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
            if (internalBatteryInfo.temp < 10) spacer = "0";
          }

          return FittedBox(
              child: Center(
                  child: Column(
            children: [
                Row(children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text('Motor Temp',
                      style: TextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.bold)),
                ),
                MicrodividerWidgetd(height: 0),
                StreamBuilder(
                    stream: settingsController.getMotorTempStream(),
                    builder: (c, sn) {
                      if (sn.data != null) {
                        unit = sn.data!;
                      }
                      return Text(unit);
                    },
                  )
                ]),
                Row(children: [
                  Text('${internalBatteryInfo.temp.toStringAsFixed(1)}',
                      style: TextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.bold)),
                ]),
              SfLinearGauge(
                minimum: 0,
                maximum: 150,
                minorTicksPerInterval: 0,
                showLabels: true,
                useRangeColorForAxis: true,
                ranges: <LinearGaugeRange>[
                  // low
                  LinearGaugeRange(
                      startValue: 0,
                      endValue: 150,
                      color: SailyBlue,
                      shaderCallback: (bounds) => LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [SailyBlue, Colors.redAccent])
                          .createShader(bounds)),
                ],
                barPointers: <LinearBarPointer>[
                  LinearBarPointer(
                    value: internalBatteryInfo.temp,
                    color: SailyBlue,
                  )
                ],
                markerPointers: <LinearMarkerPointer>[
                  LinearShapePointer(value: internalBatteryInfo.temp)
                ],
              ),
            ],
          )));
        });
    return StreamBuilder(
        stream: settingsController.getBatteryInfoStream(),
        builder: (bc, snapshot) {
          String spacer = "";
          // read data
          if (snapshot.data != null) {
            internalBatteryInfo = snapshot.data!;
            if (internalBatteryInfo.temp < 10) spacer = "0";
          }

          return Container(
            child: Column(
              children: [
                Row(children: [
                  Text("Motor Temp: "),
                  StreamBuilder(
                    stream: settingsController.getMotorTempStream(),
                    builder: (c, sn) {
                      if (sn.data != null) {
                        unit = sn.data!;
                      }
                      return Text(unit);
                    },
                  )
                ]),
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
