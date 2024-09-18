import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:saily/datatypes/nmea2000_info.dart';
import 'package:saily/settings/settings_controller.dart';
import 'package:saily/utils/saily_utils.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';


class SpeedGauge extends StatefulWidget {
  SpeedGauge({required this.settingsController});

  SettingsController settingsController;

  @override
  _SpeedGaugeState createState() => _SpeedGaugeState();
}

class _SpeedGaugeState extends State<SpeedGauge> {
  VTGInfo info = VTGInfo(isFixed: false, satellitesCount: 0, SOG: 0);

  @override
  Widget build(BuildContext context) {
    return  StreamBuilder<VTGInfo>(
      stream: widget.settingsController.getNVTGStream(),
      builder: (context, snapshot) {
        if (snapshot.data != null) info = snapshot.data!;
        return FittedBox(
          child: Container(
            padding: EdgeInsets.all(20),
            child: SizedBox(
              height: 100,
              width: gCtxW() * 0.55,
              child: SfRadialGauge(
                title: GaugeTitle(text: "km/h"),
                      axes: <RadialAxis>[
                        RadialAxis(startAngle: 270,
                            endAngle: 270,
                            minimum: 0,
                            maximum: 80,
                            interval: 10,
                            radiusFactor: 0.4,
                            showAxisLine: false,
                            showLastLabel: false,
                            minorTicksPerInterval: 4,
                            majorTickStyle: MajorTickStyle(
                                length: 8, thickness: 3, color: Colors.white),
                            minorTickStyle: MinorTickStyle(
                                length: 3, thickness: 1.5, color: Colors.grey),
                            axisLabelStyle: GaugeTextStyle(color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                            onLabelCreated: labelCreated
                        ),
                        RadialAxis(minimum: 0,
                            maximum: 200,
                            labelOffset: 30,
                            axisLineStyle: AxisLineStyle(
                                thicknessUnit: GaugeSizeUnit.factor, thickness: 0.03),
                            majorTickStyle: MajorTickStyle(
                                length: 6, thickness: 4, color: Colors.white),
                            minorTickStyle: MinorTickStyle(
                                length: 3, thickness: 3, color: Colors.white),
                            axisLabelStyle: GaugeTextStyle(color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                            ranges: <GaugeRange>[
                              GaugeRange(startValue: 0,
                                  endValue: 200,
                                  sizeUnit: GaugeSizeUnit.factor,
                                  startWidth: 0.03,
                                  endWidth: 0.03,
                                  gradient: SweepGradient(
                                      colors: const<Color>[
                                        Colors.green,
                                        Colors.yellow,
                                        Colors.red
                                      ],
                                      stops: const<double>[0.0, 0.5, 1]))
                            ],
                            pointers: <GaugePointer>[
                              NeedlePointer(value: info.SOG,
                                  needleLength: 0.95,
                                  enableAnimation: true,
                                  animationType: AnimationType.ease,
                                  needleStartWidth: 1.5,
                                  needleEndWidth: 6,
                                  needleColor: Colors.red,
                                  knobStyle: KnobStyle(knobRadius: 0.09,sizeUnit: GaugeSizeUnit.factor))
                            ],
                            annotations: <GaugeAnnotation>[
                              GaugeAnnotation(widget: Container(child:
                              Column(
                                  children: [
                                    Text(info.SOG.toStringAsFixed(0), style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                                  ]
                              )), angle: 90, positionFactor: 1.5)
                            ]
                        )
                      ]
                  ),
            ),
          ),
        );
      }
    );
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
    }
    else if (args.text == '10')
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
    else if (args.text == '70')
      args.text = '';
  }
}