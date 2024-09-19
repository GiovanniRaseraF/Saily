import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:saily/datatypes/nmea2000_info.dart';
import 'package:saily/main.dart';
import 'package:saily/settings/settings_controller.dart';
import 'package:saily/utils/saily_colors.dart';
import 'package:saily/utils/saily_utils.dart';
import 'package:saily/widgets/soc_gauge.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class SpeedGauge extends StatefulWidget {
  SpeedGauge({required this.settingsController});

  SettingsController settingsController;

  @override
  _SpeedGaugeState createState() =>
      _SpeedGaugeState(settingsController: settingsController);
}

class _SpeedGaugeState extends State<SpeedGauge> {
  _SpeedGaugeState({required this.settingsController}) {
    sogUnit = settingsController.getCurrentSogUnit();
  }

  SettingsController settingsController;
  VTGInfo info = VTGInfo(isFixed: false, satellitesCount: 0, SOG: 0);
  String sogUnit = "km/h";

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
        stream: settingsController.getSogUnitStream(),
        builder: (context, snapSogUnit) {
          if (snapSogUnit.data != null) sogUnit = snapSogUnit.data!;
          return StreamBuilder<VTGInfo>(
              stream: settingsController.getNVTGStream(),
              builder: (context, snapshot) {
                if (snapshot.data != null) info = snapshot.data!;
                return
                      FittedBox(
                        child: Container(
                          padding: EdgeInsets.all(20),
                          child: SizedBox(
                            height: 200,
                            width: 200,
                            child: SfRadialGauge(axes: <RadialAxis>[
                              RadialAxis(
                                  minimum: 0,
                                  maximum: 150,
                                  showLabels: false,
                                  axisLineStyle: AxisLineStyle(
                                      gradient: SweepGradient(
                                          colors: [SailyWhite, SailyBlue], 
                                          stops: [0.0, 1]
                                        ),
                                    thicknessUnit: GaugeSizeUnit.factor, thickness: 0.05),
                                  minorTicksPerInterval: 5,
                                  majorTickStyle: MajorTickStyle(length: 25, thickness: 3,color: Colors.white),
                                  minorTickStyle: MinorTickStyle(length: 15, thickness: 1,color: Colors.white),
                                  ranges: <GaugeRange>[
                                    GaugeRange(
                                        startValue: 0,
                                        rangeOffset: 0.05,
                                        endValue: info.SOG,
                                        sizeUnit: GaugeSizeUnit.factor,
                                        startWidth: 0.1,
                                        endWidth: 0.1,
                                        gradient: SweepGradient(
                                          colors: [Colors.white,SailySuperGreen], 
                                          stops: [0.0, 1]
                                        )
                                      )
                                  ],
                                  pointers: <GaugePointer>[],
                                  annotations: <GaugeAnnotation>[
                                    GaugeAnnotation(
                                        widget: Container(
                                            child: Column(children: [
                                          SOCGauge(settingsController: settingsController, small: false),
                                          Divider(color: Colors.transparent,height: 25,),
                                          Text(info.SOG.toStringAsFixed(0),  style: TextStyle(color: SailyWhite,fontSize: 25,fontWeight: FontWeight.bold)),
                                          Text(sogUnit,style: TextStyle(color: SailyWhite,fontSize: 15,fontWeight: FontWeight.bold)),
                                        ])),
                                        angle: 90,
                                        positionFactor: 0.55)
                                  ])
                            ]),
                          ),
                        ),
                      );
                    });
              });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void labelCreated(AxisLabelCreatedArgs args) {
    if (args.text == '0') {
      args.text = 'N';
      args.labelStyle = GaugeTextStyle(
          color: Colors.red, fontWeight: FontWeight.bold, fontSize: 14);
    } else if (args.text == '10')
      args.text = '';
    else if (args.text == '20')
      args.text = 'E';
    else if (args.text == '30')
      args.text = '';
    else if (args.text == '40')
      args.text = 'S';
    else if (args.text == '50')
      args.text = '';
    else if (args.text == '60')
      args.text = 'W';
    else if (args.text == '70') args.text = '';
  }
}
