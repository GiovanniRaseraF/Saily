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
import 'package:saily/widgets/gps_counter.dart';
import 'package:saily/widgets/microdivider_widget.dart';

class SOGGauge extends StatefulWidget {
  SOGGauge({required this.settingsController, required this.small});

  SettingsController settingsController;
  bool small;
  @override
  State<SOGGauge> createState() =>
      _SOGGaugeState(settingsController: settingsController, small: small);
}

class _SOGGaugeState extends State<SOGGauge> {
  _SOGGaugeState({required this.settingsController, required this.small}) {}

  SettingsController settingsController;
  bool small;

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
                Text("SOG: Km/h"),
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
                Text("SOG: Km/h"),
                Row(
                  children: [
                    Text(
                      "${gpsData.SOG.toStringAsFixed(1)}",
                      style: TextStyle(fontSize: 38),
                    ),
                  ],
                )
              ],
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
