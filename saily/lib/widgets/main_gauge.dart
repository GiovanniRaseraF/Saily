/*
author: Giovanni Rasera
*/

import 'dart:async';
import 'dart:convert';

import 'package:cupertino_battery_indicator/cupertino_battery_indicator.dart';
import 'package:flutter/material.dart';
import 'package:saily/datatypes/electricmotor_info.dart';
import 'package:saily/datatypes/nmea2000_info.dart';
import 'package:saily/datatypes/highpowerbattery_info.dart';
import 'package:saily/settings/settings_controller.dart';
import 'package:saily/utils/saily_colors.dart';
import 'package:saily/utils/saily_utils.dart';
import 'package:saily/widgets/electricmotortemp_gauge.dart';
import 'package:saily/widgets/gps_counter.dart';
import 'package:saily/widgets/microdivider_widget.dart';
import 'package:saily/widgets/speed_gauge.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class MainGauge extends StatefulWidget {
  MainGauge({required this.settingsController, required this.small});

  SettingsController settingsController;
  bool small;
  @override
  State<MainGauge> createState() =>
      _MainGaugeState(settingsController: settingsController, small: small);
}

class _MainGaugeState extends State<MainGauge> {
  _MainGaugeState({required this.settingsController, required this.small});

  SettingsController settingsController;
  bool small;
  String unit = "";

  Widget buildSmall(BuildContext c) {
    return StreamBuilder(
        stream: settingsController.getHighPowerBatteryInfoStream(),
        builder: (bc, snapshot) {
          HighpowerbatteryInfo info = HighpowerbatteryInfo();
          // read data
          if (snapshot.data != null) {
            info = snapshot.data!;
          }

          return Container(
            child: Column(
              children: [
                Row(children: [
                  Text("Power: KW"),
                ]),
                Row(
                  children: [
                    Text(
                      "${info.power.toStringAsFixed(1)}",
                      style: TextStyle(fontSize: 25),
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }

  Widget buildBig(BuildContext c) {
    return FittedBox(
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Power and RPM
            StreamBuilder(
                stream: settingsController.getElectricMotorInfoStream(),
                builder: (context, snapshot) {
                  ElectricmotorInfo info = ElectricmotorInfo();
                  // read data
                  if (snapshot.data != null) {
                    info = snapshot.data!;
                  }
        
                  return SizedBox(
                    height: 140,
                    width: gCtxW() * 0.33,
                    child: Center(
                      child: SfRadialGauge(
                          title: GaugeTitle(
                              text: 'RPM',
                              textStyle: TextStyle(
                                  fontSize: 15.0, fontWeight: FontWeight.bold)),
                          axes: <RadialAxis>[
                            RadialAxis(
                                canRotateLabels: false,
                                showFirstLabel: false,
                                showLastLabel: false,
                                canScaleToFit: true,
                                showLabels: false,
                                showAxisLine: false,
                                showTicks: false,
                                minimum: 0,
                                maximum: 8000,
                                startAngle: 180,
                                endAngle: -90,
                                ranges: <GaugeRange>[
                                  GaugeRange(
                                      startValue: 0,
                                      endValue: 8000,
                                      color: SailyLightGrey,
                                      startWidth: 5,
                                      endWidth: 15),
                                  GaugeRange(
                                      startValue: 0,
                                      endValue: info.motorRPM,
                                      gradient:
                                          SweepGradient(colors: [SailyLightGreen]),
                                      startWidth: 5,
                                      endWidth: (15 / 8000) * info.motorRPM),
                                ],
                                pointers: [],
                                annotations: <GaugeAnnotation>[
                                  GaugeAnnotation(
                                      widget: Container(
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                  "${(info.motorRPM).toStringAsFixed(0)}",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.bold)),
                                            ]),
                                      ),
                                      angle: 0,
                                      positionFactor: 0.5)
                                ])
                          ]),
                    ),
                  );
                }),

            SpeedGauge(settingsController: settingsController),
            StreamBuilder(
                stream: settingsController.getHighPowerBatteryInfoStream(),
                builder: (context, snapshot) {
                  HighpowerbatteryInfo info = HighpowerbatteryInfo();
                  // read data
                  if (snapshot.data != null) {
                    info = snapshot.data!;
                  }
                  return SizedBox(
                    height: 140,
                    width: gCtxW() * 0.33,
                    child: Center(
                      child: SfRadialGauge(
                          animationDuration: 1000,
                          title: GaugeTitle(
                              text: 'Power',
                              textStyle: TextStyle(
                                  fontSize: 15.0, fontWeight: FontWeight.bold)),
                          axes: <RadialAxis>[
                            RadialAxis(
                                canRotateLabels: false,
                                showFirstLabel: false,
                                showLastLabel: false,
                                canScaleToFit: true,
                                showLabels: false,
                                showAxisLine: false,
                                showTicks: false,
                                minimum: 0,
                                maximum: 150,
                                startAngle: -90,
                                endAngle: 0,
                                isInversed: true,
                                ranges: <GaugeRange>[
                                  GaugeRange(
                                      startValue: 0,
                                      endValue: 150,
                                      color: SailyLightGrey,
                                      startWidth: 5,
                                      endWidth: 15),
                                  GaugeRange(
                                      startValue: 0,
                                      endValue: info.power,
                                      gradient: SweepGradient(colors: [
                                        SailyBlue,
                                        SailyOrange,
                                        Colors.red
                                      ]),
                                      startWidth: 5,
                                      endWidth: (15 / 150) * info.power),
                                ],
                                pointers: [],
                                annotations: <GaugeAnnotation>[
                                  GaugeAnnotation(
                                      widget: Column(
                                            children: [
                                              Text(
                                                  "${info.power.toStringAsFixed(1)}",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),

                                              Text(
                                                  "KW",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),
                                            ]),
                                      
                                      angle: 90,
                                      positionFactor: 0.5)
                                ])
                          ]),
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext c) {
    unit = settingsController.getCurrentSogUnit();
    if (small) {
      return buildSmall(c);
    } else {
      return buildBig(c);
    }
  }
}
