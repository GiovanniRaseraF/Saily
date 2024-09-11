/*
author: Giovanni Rasera
*/

import 'dart:async';
import 'dart:convert';

import 'package:cupertino_battery_indicator/cupertino_battery_indicator.dart';
import 'package:flutter/material.dart';
import 'package:saily/datatypes/battery_info.dart';
import 'package:saily/datatypes/gps_info.dart';
import 'package:saily/settings/settings_controller.dart';
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
                Row(children: [Text("SOG: "), StreamBuilder(stream: settingsController.getSogUnitStream(), builder: (c, sn){
                  if(sn.data != null){
                    unit = sn.data!;
                  }
                  return Text(unit);
                },)]),
                Row(
                  children: [
                    Text("${gpsData.SOG.toStringAsFixed(1)}", style: TextStyle(fontSize: 25),
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }

  Widget buildBig(BuildContext c) {
    return Container(
      height: 200,
      width: gCtxW() * 0.40,
      child: SfRadialGauge(
          title: GaugeTitle(
              text: 'SOG',
              textStyle:
                  TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold)),
          axes: <RadialAxis>[
            RadialAxis(minimum: 0, maximum: 150, startAngle: 210, endAngle: -30, ranges: <GaugeRange>[
              GaugeRange(
                  startValue: 0,
                  endValue: 50,
                  color: Colors.green,
                  startWidth: 10,
                  endWidth: 10),
            ], pointers: <GaugePointer>[
              NeedlePointer(
                value: 90,
                needleEndWidth: 1,
                needleStartWidth: .1,
                )
            ], annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                  widget: Container(
                      child: Text('90.0',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold))),
                  angle: 90,
                  positionFactor: 0.5)
            ])
          ]),
    );
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
                Row(children: [Text("SOG: "), StreamBuilder(stream: settingsController.getSogUnitStream(), builder: (c, sn){
                  if(sn.data != null){
                    unit = sn.data!;
                  }
                  return Text(unit);
                },)]),
                Row(
                  children: [
                    Text("${gpsData.SOG.toStringAsFixed(1)}", style: TextStyle(fontSize: 38),),
                  ],
                )
              ],
            ),
          );
        });
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
