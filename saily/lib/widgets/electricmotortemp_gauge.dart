/*
author: Giovanni Rasera
*/

import 'dart:async';
import 'dart:convert';

import 'package:cupertino_battery_indicator/cupertino_battery_indicator.dart';
import 'package:flutter/material.dart';
import 'package:saily/datatypes/electricmotor_info.dart';
import 'package:saily/datatypes/highpowerbattery_info.dart';
import 'package:saily/settings/settings_controller.dart';
import 'package:saily/utils/saily_colors.dart';
import 'package:saily/widgets/microdivider_widget.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class ElectricMotorTempGauge extends StatefulWidget {
  ElectricMotorTempGauge({required this.settingsController, required this.small});

  SettingsController settingsController;
  bool small;
  @override
  State<ElectricMotorTempGauge> createState() => _ElectricMotorTempGaugeState(
      settingsController: settingsController, small: small);
}

class _ElectricMotorTempGaugeState extends State<ElectricMotorTempGauge> {
  _ElectricMotorTempGaugeState(
      {required this.settingsController, required this.small}) {}

  ElectricmotorInfo internalElectricMotorInfo = ElectricmotorInfo();
  SettingsController settingsController;
  bool small = true;
  String unit = "";

  Widget buildSmall(BuildContext c) {
    return StreamBuilder(
        stream: settingsController.getElectricMotorInfoStream(),
        builder: (bc, snapshot) {
          String spacer = "";
          // read data
          if (snapshot.data != null) {
            internalElectricMotorInfo = snapshot.data!;
            if (internalElectricMotorInfo.motorTemperature < 10) spacer = "0";
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
                  "${spacer}${internalElectricMotorInfo.motorTemperature.toStringAsFixed(1)}",
                  style: TextStyle(fontSize: 25),
                )
              ],
            ),
          );
        });
  }

  Widget buildBig(BuildContext c) {
    return StreamBuilder(
        stream: settingsController.getElectricMotorInfoStream(),
        builder: (bc, snapshot) {
          String spacer = "";
          // read data
          if (snapshot.data != null) {
            internalElectricMotorInfo = snapshot.data!;
            if (internalElectricMotorInfo.motorTemperature < 10) spacer = "0";
          }

          return Column(
            children: [
              FittedBox(
                  child: Center(
                      child: Column(
                children: [
                    Row(children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text('Motor Temperature',
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
                      Text('${internalElectricMotorInfo.motorTemperature.toStringAsFixed(1)}',
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
                      LinearShapePointer(value: internalElectricMotorInfo.motorTemperature),
                      LinearShapePointer( value: 50, color: SailyBlue),
                      LinearShapePointer( value: 100, color: SailyOrange)
                    ],

                  ),

                  // Inverter Temperature
                Row(children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text('Inverter Temperature',
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
                      Text('${internalElectricMotorInfo.inverterTemperature.toStringAsFixed(1)}',
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
                      LinearShapePointer(value: internalElectricMotorInfo.inverterTemperature),
                      LinearShapePointer( value: 50, color: SailyBlue),
                      LinearShapePointer( value: 100, color: SailyOrange)
                    ],
                  ),

                ],

                // Inverter

              ))),
            ],
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
