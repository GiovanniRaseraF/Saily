/*
author: Giovanni Rasera
*/

import 'dart:async';
import 'dart:convert';

import 'package:animated_battery_gauge/animated_battery_gauge.dart';
import 'package:animated_battery_gauge/battery_gauge.dart';
import 'package:cupertino_battery_indicator/cupertino_battery_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:saily/datatypes/highpowerbattery_info.dart';
import 'package:saily/datatypes/nmea2000_info.dart';
import 'package:saily/main.dart';
import 'package:saily/settings/settings_controller.dart';
import 'package:saily/utils/saily_colors.dart';
import 'package:saily/utils/saily_utils.dart';
import 'package:saily/widgets/microdivider_widget.dart';
import 'package:saily/widgets/main_gauge.dart';
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
  _SOGGaugeState({required this.settingsController, required this.small}) {
    unit = settingsController.getCurrentSogUnit();
  }

  VTGInfo info = VTGInfo(isFixed: false, satellitesCount: 0, SOG: 0);

  String unit = "";
  SettingsController settingsController;
  bool small = true;

  Widget buildSmall(BuildContext c) {
    return
       StreamBuilder(
          stream: settingsController.getNVTGStream(),
          builder: (bc, snapshot) {
            // read data
            if (snapshot.data != null) info = snapshot.data!;
            return 
                SizedBox(
                  width: gCtxW() * 0.15,
                  child: Column(
                    children: [
                      Text("${info.SOG}", style: TextStyle(fontSize: 10)),
                      StreamBuilder(stream: settingsController.getSogUnitStream(), builder: (c, sn){
                        if (sn.data != null) unit = sn.data!;
                        return Text("${unit}", style: TextStyle(fontSize: 10.0, fontWeight: FontWeight.bold));
                      }) 
                    ],
                  ),
                );
          });
  }

  Widget buildBig(BuildContext c) {
    return
       StreamBuilder(
          stream: settingsController.getNVTGStream(),
          builder: (bc, snapshot) {
            // read data
            if (snapshot.data != null) info = snapshot.data!;
            return 
                SizedBox(
                  width: gCtxW() * 0.15,
                  child: Column(
                    children: [
                      Text("${info.SOG}", style: TextStyle(fontSize: 15)),
                      StreamBuilder(stream: settingsController.getSogUnitStream(), builder: (c, sn){
                        if (sn.data != null) unit = sn.data!;
                        return Text("${unit}", style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold));
                      }) 
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
