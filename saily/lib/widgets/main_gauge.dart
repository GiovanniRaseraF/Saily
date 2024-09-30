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
import 'package:saily/widgets/temps/batterytemp_gauge.dart';
import 'package:saily/widgets/gps_counter.dart';
import 'package:saily/widgets/microdivider_widget.dart';
import 'package:saily/widgets/rpm_gauge.dart';
import 'package:saily/widgets/soc_gauge.dart';
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
        child: Stack(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // rpm
              RPMGauge(settingsController: settingsController, small: small),
              // Speed
              SpeedGauge(settingsController: settingsController),
            ],
          ),
          Positioned(top: 0, left: 185,
            //child: SizedBox(width: 200, child: Card(color: SailyLightOrange,),),
            child: Image.asset("images/huracan.png", scale: 15, fit: BoxFit.contain)
          )
        ]),
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
