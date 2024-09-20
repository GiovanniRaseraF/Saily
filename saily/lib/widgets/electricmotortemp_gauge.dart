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
  ElectricMotorTempGauge(
      {required this.settingsController, required this.small});

  SettingsController settingsController;
  bool small;
  @override
  State<ElectricMotorTempGauge> createState() => _ElectricMotorTempGaugeState(
      settingsController: settingsController, small: small);
}

class _ElectricMotorTempGaugeState extends State<ElectricMotorTempGauge> {
  _ElectricMotorTempGaugeState({required this.settingsController, required this.small}) {
    unit = settingsController.getMotorTempUnit();
  }

  ElectricmotorInfo info = ElectricmotorInfo();
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
            info = snapshot.data!;
            if (info.motorTemperature < 10) spacer = "0";
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
                  "${spacer}${info.motorTemperature.toStringAsFixed(1)}",
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
            info = snapshot.data!;
            if (info.motorTemperature < 10) spacer = "0";
          }

          return Column(
            children: [
              FittedBox(
                  child: SizedBox(
                    width: 100,
                child: Center(
                    child: Column(
                  children: [
                    Row(children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text('Motor T.',
                            style: TextStyle(color: SailyWhite,fontSize: 15.0, fontWeight: FontWeight.bold)),
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
                      Text('${info.motorTemperature.toStringAsFixed(0)}',style: TextStyle(color: SailyWhite, fontSize: 15.0, fontWeight: FontWeight.bold)),
                    ]),
                    SfLinearGauge(
                      minimum: 0,
                      maximum: 150,
                      minorTicksPerInterval: 0,
                      showLabels: true,
                      useRangeColorForAxis: true,
                      showAxisTrack: false,
                      ranges: <LinearGaugeRange>[
                        // low
                        LinearGaugeRange(
                            startValue: 0,
                            endValue: info.motorTemperature,
                            color: SailyBlue,
                            shaderCallback: (bounds) => LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [SailyWhite, SailySuperRed])
                                .createShader(bounds)),
                      ],
                      barPointers: [],
                      markerPointers: [],
                    ),
                   ],

                  // Inverter
                )
                ),
            )),
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
