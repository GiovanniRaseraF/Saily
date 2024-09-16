/*
author: Giovanni Rasera
*/

import 'dart:async';
import 'dart:convert';

import 'package:cupertino_battery_indicator/cupertino_battery_indicator.dart';
import 'package:flutter/material.dart';
import 'package:saily/datatypes/gps_info.dart';
import 'package:saily/settings/settings_controller.dart';
import 'package:saily/utils/saily_colors.dart';
import 'package:saily/utils/saily_utils.dart';
import 'package:saily/widgets/gps_counter.dart';
import 'package:saily/widgets/microdivider_widget.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class SOGGauge extends StatefulWidget {
  SOGGauge({required this.settingsController, required this.small});

  SettingsController settingsController;
  bool small;
  @override
  State<SOGGauge> createState() =>
      _SOGGaugeState(settingsController: settingsController, small: small);
}

class _SOGGaugeState extends State<SOGGauge> {
  _SOGGaugeState({required this.settingsController, required this.small});

  SettingsController settingsController;
  bool small;
  String unit = "";

  GpsInfo gpsData = GpsInfo(isFixed: false, satellitesCount: 0, SOG: 0);

  Widget buildSmall(BuildContext c) {
    return StreamBuilder(
        stream: settingsController.getCurrentGpsCounterStream(),
        builder: (bc, snapshot) {
          // read data
          if (snapshot.data != null) {
            gpsData = snapshot.data!;
          }

          return Container(
            child: Column(
              children: [
                Row(children: [
                  Text("SOG: "),
                  StreamBuilder(
                    stream: settingsController.getSogUnitStream(),
                    builder: (c, sn) {
                      if (sn.data != null) {
                        unit = sn.data!;
                      }
                      return Text(unit);
                    },
                  )
                ]),
                Row(
                  children: [
                    Text(
                      "${gpsData.SOG.toStringAsFixed(1)}",
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
          children: [
            // Power and RPM
            StreamBuilder(
                stream: settingsController.getCurrentGpsCounterStream(),
                builder: (context, snapshot) {
                  // read data
                  if (snapshot.data != null) {
                    gpsData = snapshot.data!;
                  }
        
                  return SizedBox(
                    height: 140,
                    width: 120,
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
                                      endValue: gpsData.SOG * 50,
                                      gradient:
                                          SweepGradient(colors: [SailyLightGreen]),
                                      startWidth: 5,
                                      endWidth: (15 / 150) * gpsData.SOG),
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
                                                  "${(gpsData.SOG * 50).toStringAsFixed(0)}",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.bold)),
                                            ]),
                                      ),
                                      angle: 0,
                                      positionFactor: 1)
                                ])
                          ]),
                    ),
                  );
                }),
            StreamBuilder(
                stream: settingsController.getCurrentGpsCounterStream(),
                builder: (context, snapshot) {
                  // read data
                  if (snapshot.data != null) {
                    gpsData = snapshot.data!;
                  }
        
                  return SizedBox(
                    height: 140,
                    width: 120,
                    child: Center(
                      child: SfRadialGauge(
                          animationDuration: 1000,
                          title: GaugeTitle(
                              text: 'SOG',
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
                                      endValue: gpsData.SOG,
                                      gradient: SweepGradient(colors: [
                                        SailyBlue,
                                        SailyOrange,
                                        Colors.red
                                      ]),
                                      startWidth: 5,
                                      endWidth: (15 / 150) * gpsData.SOG),
                                ],
                                pointers: [],
                                annotations: <GaugeAnnotation>[
                                  GaugeAnnotation(
                                      widget: Container(
                                        child: Column(
                                            children: [
                                              Text(
                                                  "${gpsData.SOG.toStringAsFixed(1)}",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.bold)),
                                              StreamBuilder(
                                                stream: settingsController
                                                    .getSogUnitStream(),
                                                builder: (c, sn) {
                                                  if (sn.data != null) {
                                                    unit = sn.data!;
                                                  }
                                                  return Text(unit);
                                                },
                                              )
                                            ]),
                                      ),
                                      angle: 90,
                                      positionFactor: 0.6)
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
    unit = settingsController.getSogUnit();
    if (small) {
      return buildSmall(c);
    } else {
      return buildBig(c);
    }
  }
}
