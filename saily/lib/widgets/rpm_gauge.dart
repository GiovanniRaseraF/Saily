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
import 'package:saily/widgets/soc_gauge.dart';
import 'package:saily/widgets/speed_gauge.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class RPMGauge extends StatefulWidget {
  RPMGauge({required this.settingsController, required this.small});

  SettingsController settingsController;
  bool small;
  @override
  State<RPMGauge> createState() =>
      _RPMGaugeState(settingsController: settingsController, small: small);
}

class _RPMGaugeState extends State<RPMGauge> {
  _RPMGaugeState({required this.settingsController, required this.small});

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
            Stack(
              children: [
                StreamBuilder(
                    stream: settingsController.getElectricMotorInfoStream(),
                    builder: (context, snapSogUnit) {
                      ElectricmotorInfo info = ElectricmotorInfo();
                      if (snapSogUnit.data != null) info = snapSogUnit.data!;
                      return FittedBox(
                        child: Container(
                          padding: EdgeInsets.all(20),
                          child: SizedBox(
                            height: 200,
                            width: 200,
                            child: SfRadialGauge(axes: <RadialAxis>[
                              RadialAxis(
                                  minimum: 0,
                                  maximum: 80,
                                  interval: 10,
                                  showAxisLine: false,
                                  showLabels: false,
                                  showLastLabel: false,
                                  ),
                              RadialAxis(
                                  minimum: 0,
                                  maximum: 8000,
                                  showLabels: false,
                                  axisLineStyle: AxisLineStyle(
                                    gradient: SweepGradient(
                                      colors: [SailyBlue, SailySuperRed], 
                                      stops: [0.0, 1]
                                    ),
                                    thicknessUnit: GaugeSizeUnit.factor, thickness: 0.05
                                  ),
                                  minorTicksPerInterval: 5,
                                  majorTickStyle: MajorTickStyle(length: 25, thickness: 6,color: Colors.white),
                                  minorTickStyle: MinorTickStyle(length: 15, thickness: 3,color: Colors.white),
                                  ranges: <GaugeRange>[
                                    GaugeRange(
                                        startValue: 0,
                                        rangeOffset: 0.05,
                                        endValue: info.motorRPM,
                                        sizeUnit: GaugeSizeUnit.factor,
                                        startWidth: 0.1,
                                        endWidth: 0.1,
                                        gradient: SweepGradient(
                                          colors: [Colors.white,SailyBlue,], 
                                          stops: [0.0, 1]
                                        )
                                      )
                                  ],
                                  pointers: <GaugePointer>[],
                                  annotations: <GaugeAnnotation>[
                                    GaugeAnnotation(
                                        widget: Container(
                                            child: Column(children: [
                                              SOCGauge(settingsController: settingsController, small: small),
                                              Divider(color: Colors.transparent,height: 25,),
                                              Text(info.motorRPM.toStringAsFixed(0),  style: TextStyle(color: SailyWhite,fontSize: 25,fontWeight: FontWeight.bold)),
                                              Text("RPM",style: TextStyle(color: SailyWhite,fontSize: 15,fontWeight: FontWeight.bold)),
                                        ])),
                                        angle: 90,
                                        positionFactor: 0.55)
                                  ])
                            ]),
                          ),
                        ),
                      );
                    }),
                    
              ],
            ),
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
