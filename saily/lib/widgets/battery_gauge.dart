/*
author: Giovanni Rasera
*/

import 'dart:async';
import 'dart:convert';

import 'package:cupertino_battery_indicator/cupertino_battery_indicator.dart';
import 'package:flutter/material.dart';
import 'package:saily/datatypes/battery_info.dart';
import 'package:saily/settings/settings_controller.dart';
import 'package:saily/widgets/microdivider_widget.dart';

class BatteryGauge extends StatefulWidget {
  BatteryGauge({required this.settingsController, required this.small});

  SettingsController settingsController;
  bool small;
  @override
  State<BatteryGauge> createState() =>
      _BatteryGaugeState(settingsController: settingsController, small : small);
}

class _BatteryGaugeState extends State<BatteryGauge> {
  _BatteryGaugeState({required this.settingsController, required this.small}) {
  }

  BatteryInfo internalBatteryInfo = BatteryInfo(SOC: 0);
  SettingsController settingsController;
  bool small;

  Color getColor(double value) {
    Color color = Colors.black;
    if (value >= 0 && value < 30) {
      color = Colors.red;
    } else if (value >= 30 && value < 80) {
      color = Colors.yellow;
    } else {
      color = Colors.green;
    } 

    return color;
  }

  Widget _streamBuilderBattery() {
    return StreamBuilder(
      stream: settingsController.getBatteryInfoStream(),
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          final battData = snapshot.data!;
          internalBatteryInfo.SOC = battData.SOC;
          //debugPrint("BatterySOC: ${internalBatteryInfo.SOC}" );
        }
        double value = internalBatteryInfo.SOC.toDouble();
        Color color = getColor(value);

        return Row(
          children: [
            BatteryIndicator(barColor: color, value: value / 100),
            Text("    "),
            Text("$value %", style: TextStyle(fontWeight: FontWeight.bold))
          ],
        );
      },
    );
  }

  Widget _streamBuilderPower() {
    return StreamBuilder(
      stream: settingsController.getBatteryInfoStream(),
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          final battData = snapshot.data!;
          internalBatteryInfo.power = battData.power;
        }
        double power = internalBatteryInfo.power;

        return Row(
          children: [
            Icon(Icons.bolt, color: Colors.yellow),
            Text("${power.toStringAsFixed(1)}", style: TextStyle(fontWeight: FontWeight.bold)),
            Text("   kW", style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        );
      },
    );
  }

  Widget _streamBuilderTemp() {
    return StreamBuilder(
      stream: settingsController.getBatteryInfoStream(),
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          final battData = snapshot.data!;
          internalBatteryInfo.temp = battData.temp;
        }
        double battemp = internalBatteryInfo.temp;

        return Row(
          children: [
            Icon(Icons.thermostat, color: Colors.red),
            Text("${battemp.toStringAsFixed(1)}", style: TextStyle(fontWeight: FontWeight.bold)),
            Text("   C°", style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        );
      },
    );
  }

  Widget smallGraphics(BuildContext c) {
    return Row(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [_streamBuilderBattery()],
        ),
      ],
    );
  }

  Widget allGraphics(BuildContext c) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [_streamBuilderBattery()],
        ),
        MicrodividerWidgetd(height: 0),
        _streamBuilderPower(),
        MicrodividerWidgetd(height: 0),
        _streamBuilderTemp(),
      ],
    );
  }

  @override
  Widget build(BuildContext c) {
    // return StreamBuilder(
    //   stream: settingsController.getExpandTileStream(),
    //   builder: (context, snapshot) {
    //     print(snapshot);
    //     if (snapshot.data != null) {
    //       // small is not expanded tile value
    //       small = !(snapshot.data!);
    //       debugPrint("small: $small");
    //     }

        if (small) {
          return smallGraphics(c);
        }

        return allGraphics(c);
    //   },
    // );
  }
}
