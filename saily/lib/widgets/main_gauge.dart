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
                        width: gCtxW() * 0.65,
                        child: SfRadialGauge(axes: <RadialAxis>[
                          // RadialAxis(
                          //     startAngle: 270,
                          //     endAngle: 270,
                          //     minimum: 0,
                          //     maximum: 80,
                          //     interval: 10,
                          //     radiusFactor: 0.4,
                          //     showAxisLine: false,
                          //     showLabels: true,
                          //     showLastLabel: true,
                          //     minorTicksPerInterval: 4,
                          //     majorTickStyle: MajorTickStyle(
                          //         length: 8, thickness: 3, color: Colors.white),
                          //     minorTickStyle: MinorTickStyle(
                          //         length: 3, thickness: 1.5, color: Colors.grey),
                          //     axisLabelStyle: GaugeTextStyle(
                          //         color: Colors.white,
                          //         fontWeight: FontWeight.bold,
                          //         fontSize: 14),
                          //     ),
                          RadialAxis(
                              minimum: 0,
                              maximum: 8000,
                              showLabels: false,
                              labelOffset: 30,
                              axisLineStyle: AxisLineStyle(
                                  thicknessUnit: GaugeSizeUnit.factor,
                                  thickness: 0.03),
                              majorTickStyle: MajorTickStyle(
                                  length: 20,
                                  thickness: 4,
                                  color: Colors.white),
                              minorTickStyle: MinorTickStyle(
                                  length: 15,
                                  thickness: 3,
                                  color: Colors.white),
                              axisLabelStyle: GaugeTextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14),
                              ranges: <GaugeRange>[
                                GaugeRange(
                                    startValue: 0,
                                    endValue: info.motorRPM,
                                    sizeUnit: GaugeSizeUnit.factor,
                                    startWidth: 0.1,
                                    endWidth: 0.1,
                                    gradient: SweepGradient(colors: <Color>[
                                      Colors.white,
                                      SailyBlue,
                                    ], stops: const <double>[
                                      0.0,
                                      1
                                    ]))
                              ],
                              pointers: <GaugePointer>[
                                // NeedlePointer(
                                //     value: info.motorRPM,
                                //     needleLength: 0.5,
                                //     enableAnimation: true,
                                //     animationType: AnimationType.ease,
                                //     needleStartWidth: 2,
                                //     needleEndWidth: 2,
                                //     needleColor: Colors.white,
                                //     knobStyle: KnobStyle(
                                //         knobRadius: 0.0,sizeUnit: GaugeSizeUnit.factor))
                              ],
                              annotations: <GaugeAnnotation>[
                                GaugeAnnotation(
                                    widget: Container(
                                        child: Column(children: [
                                      Text(info.motorRPM.toStringAsFixed(0),
                                          style: TextStyle(
                                              color: SailyWhite,
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold)),
                                      Text("RPM",
                                          style: TextStyle(
                                              color: SailyWhite,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold)),
                                    ])),
                                    angle: 90,
                                    positionFactor: 1.5)
                              ])
                        ]),
                      ),
                    ),
                  );
                }),

            // Power and RPM
            // StreamBuilder(
            //     stream: settingsController.getElectricMotorInfoStream(),
            //     builder: (context, snapshot) {
            //       ElectricmotorInfo info = ElectricmotorInfo();
            //       // read data
            //       if (snapshot.data != null) {
            //         info = snapshot.data!;
            //       }

            //       return SizedBox(
            //         height: 140,
            //         width: gCtxW() * 0.33,
            //         child: Center(
            //           child: SfRadialGauge(
            //               // title: GaugeTitle(
            //               //     text: 'RPM',
            //               //     textStyle: TextStyle(
            //               //         fontSize: 15.0, fontWeight: FontWeight.bold)),
            //               axes: <RadialAxis>[
            //                 RadialAxis(
            //                     canScaleToFit: true,
            //                     showLabels: false,
            //                     showAxisLine: false,
            //                     minimum: 0,
            //                     maximum: 8000,
            //                     startAngle: 90,
            //                     endAngle: -90,
            //                     ranges: <GaugeRange>[
            //                       GaugeRange(
            //                           startValue: 0,
            //                           endValue: 8000,
            //                           color: SailyLightGrey,
            //                           startWidth: 5,
            //                           endWidth: 15),
            //                       GaugeRange(
            //                           startValue: 0,
            //                           endValue: info.motorRPM,
            //                           gradient:
            //                               SweepGradient(colors: [SailyBlue]),
            //                           startWidth: 5,
            //                           endWidth: 15 ),
            //                     ],
            //                     showTicks: true,
            //                     axisLabelStyle: GaugeTextStyle(
            //                       color: Colors.white,
            //                       fontWeight: FontWeight.bold,
            //                       fontSize: 10),
            //                   pointers: <GaugePointer>[
            //                   NeedlePointer(
            //                       value: info.motorRPM,
            //                       needleLength: 0.95,
            //                       enableAnimation: true,
            //                       animationType: AnimationType.linear,
            //                       needleStartWidth: 1.5,
            //                       needleEndWidth: 6,
            //                       needleColor: Colors.red,
            //                       knobStyle: KnobStyle(
            //                           knobRadius: 0.09,
            //                           sizeUnit: GaugeSizeUnit.factor))
            //                   ],

            //                     annotations: <GaugeAnnotation>[
            //                       GaugeAnnotation(
            //                           widget: Container(
            //                             child: Column(
            //                                 children: [
            //                                   Text(
            //                                       "${(info.motorRPM).toStringAsFixed(0)}",
            //                                       style: TextStyle(
            //                                           fontSize: 15,
            //                                           color: SailyWhite,
            //                                           fontWeight: FontWeight.bold)),
            //                                 Text(
            //                                       "RPM",
            //                                       style: TextStyle(
            //                                           fontSize: 15,
            //                                           color: SailyWhite,
            //                                           fontWeight: FontWeight.bold)),
            //                                 ]),
            //                           ),
            //                           angle: 90,
            //                           positionFactor: 1)
            //                     ])
            //               ]),
            //         ),
            //       );
            //     }),

            // StreamBuilder(
            //     stream: settingsController.getHighPowerBatteryInfoStream(),
            //     builder: (context, snapshot) {
            //       HighpowerbatteryInfo info = HighpowerbatteryInfo();
            //       // read data
            //       if (snapshot.data != null) {
            //         info = snapshot.data!;
            //       }
            //       return SizedBox(
            //         height: 140,
            //         width: gCtxW() * 0.33,
            //         child: Center(
            //           child: SfRadialGauge(
            //               animationDuration: 1000,
            //               // title: GaugeTitle(
            //               //     text: 'Powe',
            //               //     textStyle: TextStyle(
            //               //         fontSize: 15.0, fontWeight: FontWeight.bold)),
            //               axes: <RadialAxis>[
            //                 RadialAxis(
            //                     canRotateLabels: false,
            //                     showFirstLabel: false,
            //                     showLastLabel: false,
            //                     canScaleToFit: true,
            //                     showLabels: false,
            //                     showAxisLine: false,
            //                     showTicks: false,
            //                     minimum: 0,
            //                     maximum: 150,
            //                     startAngle: -90,
            //                     endAngle: 90,
            //                     isInversed: true,
            //                     ranges: <GaugeRange>[
            //                       GaugeRange(
            //                           startValue: 0,
            //                           endValue: 150,
            //                           color: SailyLightGrey,
            //                           startWidth: 5,
            //                           endWidth: 15),
            //                       GaugeRange(
            //                           startValue: 0,
            //                           endValue: 150,
            //                           gradient: SweepGradient(colors: [
            //                             SailyBlue,
            //                             SailyOrange,
            //                             Colors.red
            //                           ]),
            //                           startWidth: 5,
            //                           endWidth: 15),
            //                     ],
            //                     pointers: [],
            //                     annotations: <GaugeAnnotation>[
            //                       GaugeAnnotation(
            //                           widget: Column(
            //                                 children: [
            //                                   Text(
            //                                       "${info.power.toStringAsFixed(1)}",style: TextStyle(

            //                                         color: SailyWhite,
            //                                         fontSize: 15,fontWeight: FontWeight.bold)),

            //                                   Text(
            //                                       "KW",style: TextStyle(
            //                                           color: SailyWhite,
            //                                         fontSize: 15,fontWeight: FontWeight.bold)),
            //                                 ]),

            //                           angle: 90,
            //                           positionFactor: 1)
            //                     ])
            //               ]),
            //         ),
            //       );
            //     }),

            SpeedGauge(settingsController: settingsController),
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
