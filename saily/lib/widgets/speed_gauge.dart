import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:saily/datatypes/electricmotor_info.dart';
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


    // sub to electric motor
    electricMotorInfoSubscription = settingsController.getElectricMotorInfoStream().listen((ElectricmotorInfo motorInfo){
      double diff = (minStartValueTemp - maxEndValueTemp);
      setState(() {
        simulatedValueTemp = minStartValueTemp - ((diff/ 180) * motorInfo.motorTemperature);
        actualValueTemp = motorInfo.motorTemperature;
      });
    });
  }

  late StreamSubscription<ElectricmotorInfo> electricMotorInfoSubscription;
  SettingsController settingsController;
  VTGInfo info = VTGInfo(isFixed: false, satellitesCount: 0, SOG: 0);
  String sogUnit = "km/h";

  double maxEndValueTemp = 80;
  double minStartValueTemp = 120;
  double simulatedValueTemp = 0;
  double actualValueTemp = 0;

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
                          padding: EdgeInsets.only(right: 40, left: 10, top: 40, bottom: 20),
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
                                          colors: [SailySuperGreen, SailyBlue], 
                                          stops: [0.0, 1]
                                        ),
                                    thicknessUnit: GaugeSizeUnit.factor, thickness: 0.05),
                                  minorTicksPerInterval: 5,
                                  majorTickStyle: MajorTickStyle(length: 25, thickness: 3,color: Colors.black),
                                  minorTickStyle: MinorTickStyle(length: 15, thickness: 1,color: Colors.black),
                                  ranges: <GaugeRange>[
                                    GaugeRange(
                                        startValue: 0,
                                        rangeOffset: 0.05,
                                        endValue: info.SOG,
                                        sizeUnit: GaugeSizeUnit.factor,
                                        startWidth: 0.1,
                                        endWidth: 0.1,
                                        gradient: SweepGradient(
                                          colors: [SailyBlue,SailySuperGreen], 
                                          stops: [0.0, 1]
                                        )
                                      ),

                                      // motor temperature value
                                      GaugeRange(
                                        endValue: 120,
                                        rangeOffset: -0.2,
                                        startValue: 80,
                                        sizeUnit: GaugeSizeUnit.factor,
                                        startWidth: 0.08,
                                        endWidth: 0.08,
                                        gradient: SweepGradient(
                                          colors: [SailySuperRed, SailyBlue,], stops: [0.0, 1]
                                        )
                                      )
                                  ],
                                  pointers: <GaugePointer>[
                                      // motor temperature 
                                      MarkerPointer(value: simulatedValueTemp, markerOffset: -20,),
                                      WidgetPointer(child: Text("${actualValueTemp.toStringAsFixed(0)}",  style: TextStyle(color: SailyBlack)), offset: -37, value: simulatedValueTemp),
                                      WidgetPointer(child: Icon(Icons.thermostat, color: SailySuperRed), offset: -60, value: 100),
                                      WidgetPointer(child: Text("Motor", style: TextStyle(color: SailyBlack),), offset: -74,value: 97),
                                  ],
                                  annotations: <GaugeAnnotation>[
                                    GaugeAnnotation(
                                        widget: Container(
                                            child: Column(children: [
                                          SOCGauge(settingsController: settingsController, small: false),
                                          Divider(color: Colors.transparent,height: 30,),
                                          Text(info.SOG.toStringAsFixed(0),  style: TextStyle(color: SailyBlack,fontSize: 25,fontWeight: FontWeight.bold)),
                                          Text(sogUnit,style: TextStyle(color: SailyBlack,fontSize: 15,fontWeight: FontWeight.bold)),
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
    electricMotorInfoSubscription.cancel();
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
