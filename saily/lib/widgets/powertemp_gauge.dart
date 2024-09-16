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
import 'package:saily/widgets/microdivider_widget.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class PowerTempGauge extends StatefulWidget {
  PowerTempGauge({required this.settingsController, required this.small});

  SettingsController settingsController;
  bool small;
  @override
  State<PowerTempGauge> createState() => _PowerTempGaugeState(
      settingsController: settingsController, small: small);
}

class _PowerTempGaugeState extends State<PowerTempGauge> {
  _PowerTempGaugeState(
      {required this.settingsController, required this.small}) {}

  HighpowerbatteryInfo internalBatteryInfo = HighpowerbatteryInfo();
  SettingsController settingsController;
  bool small = true;
  String unit = "";

  Widget buildSmall(BuildContext c) {
    return StreamBuilder(
        stream: settingsController.getHighPowerBatteryInfoStream(),
        builder: (bc, snapshot) {
          String spacer = "";
          // read data
          if (snapshot.data != null) {
            internalBatteryInfo = snapshot.data!;
            if (internalBatteryInfo.batteryTemperature < 10) spacer = "0";
          }

          return Container(
            child: Column(
              children: [
                Row(children: [
                  Text("Power Temp"),
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
                  "${spacer}${internalBatteryInfo.batteryTemperature.toStringAsFixed(1)}",
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
            if (internalBatteryInfo.batteryTemperature< 10) spacer = "0";
          }

          return FittedBox(
              child: Center(
                  child: Column(
            children: [
                Row(children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text('Power Temp',
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
                  Text('${internalBatteryInfo.batteryTemperature.toStringAsFixed(1)}',
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
                  
                ],
                markerPointers: <LinearMarkerPointer>[
                  LinearShapePointer( value: internalBatteryInfo.power),
                  LinearShapePointer( value: 50, color: SailyBlue),
                  LinearShapePointer( value: 100, color: SailyOrange)
                ],
              ),
            ],
          )));
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
