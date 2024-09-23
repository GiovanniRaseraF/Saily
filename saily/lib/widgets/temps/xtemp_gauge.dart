/*
author: Giovanni Rasera
*/

import 'dart:async';
import 'dart:convert';

import 'package:cupertino_battery_indicator/cupertino_battery_indicator.dart';
import 'package:flutter/material.dart';
import 'package:saily/datatypes/highpowerbattery_info.dart';
import 'package:saily/settings/settings_controller.dart';
import 'package:saily/utils/saily_colors.dart';
import 'package:saily/widgets/microdivider_widget.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class XTempGauge extends StatefulWidget {
  XTempGauge({required this.settingsController, required this.title, required this.unit, required this.startValue, required this.endValue, required this.small, required this.value});

  SettingsController settingsController;
  bool small = false;

  String title;
  String unit;
  double value = 0.0;

  double startValue;
  double endValue;

  @override
  State<XTempGauge> createState() => _XTempGaugeState();
}

class _XTempGaugeState extends State<XTempGauge> {
  _XTempGaugeState() {}


  Widget buildSmall(BuildContext c) {
    return Container(
            child: Column(
              children: [
                Row(children: [
                  Text(widget.title),
                  Text(widget.unit),
                ]),
                Text(
                  "${widget.value.toStringAsFixed(1)}",style: TextStyle(fontSize: 25),
                )
              ],
            ),
          );
  }

  Widget buildBig(BuildContext c) {
    return 
          FittedBox(
              child: Center(
                  child: Column(
            children: [
                Row(children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(widget.title,
                      style: TextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.bold)),
                ),
                MicrodividerWidgetd(height: 0),
                Text(widget.unit),
                ]),
                Row(children: [
                  Text('${widget.value.toStringAsFixed(1)}', style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold)),
                  Text('${widget.unit}', style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold)),
                ]),
              SfLinearGauge(
                minimum: widget.startValue,
                maximum: widget.endValue,
                minorTicksPerInterval: 0,
                showLabels: true,
                useRangeColorForAxis: true,
                ranges: <LinearGaugeRange>[
                  // low
                  LinearGaugeRange(
                      startValue: widget.startValue,
                      endValue: widget.endValue,
                      color: SailyBlue,
                      shaderCallback: (bounds) => LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [SailyBlue, SailyOrange, SailySuperRed],
                              stops: [0, 0.5, 0.7]
                              )
                          .createShader(bounds)),
                ],
                barPointers: <LinearBarPointer>[
                  
                ],
                markerPointers: <LinearMarkerPointer>[
                  LinearShapePointer( value: widget.value),
                  LinearShapePointer( value: widget.endValue / 3, color: SailyBlue),
                  LinearShapePointer( value: widget.endValue * (2/3), color: SailyOrange)
                ],
              ),
            ],
          )));
  }

  @override
  Widget build(BuildContext c) {
    if (widget.small) {
      return buildSmall(c);
    } else {
      return buildBig(c);
    }
  }
}
