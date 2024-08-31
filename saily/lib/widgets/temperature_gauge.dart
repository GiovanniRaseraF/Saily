/*
author: Giovanni Rasera
*/


import 'package:flutter/material.dart';
import 'package:saily/settings/settings_controller.dart';

class TemperatureGauge extends StatefulWidget {
  TemperatureGauge({  required this.settingsController, required this.small});

  SettingsController settingsController;
  bool small;

  @override
  State<TemperatureGauge> createState() => _TemperatureGauge(settingsController: settingsController, small: small);
}

class _TemperatureGauge extends State<TemperatureGauge>{
  _TemperatureGauge({required this.settingsController, required this.small});
  SettingsController settingsController;
  bool small;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(listenable: settingsController, builder: (context, child) {
      if(small){
        return _smallGraphics(context); 
      }
      return _smallGraphics(context); 
    },);
  }

  Widget _smallGraphics(BuildContext c){
   return StreamBuilder(
      stream: settingsController.getBatteryInfoStream(),
      builder: (context, snapshot) {
        double battemp = 0;
        if(snapshot.data != null){
          battemp = snapshot.data!.temp;
        }

        return  Row(children: [
          Icon(Icons.thermostat, color: Colors.red),
          Text("${battemp.toStringAsFixed(1)}", style: TextStyle(fontWeight: FontWeight.bold)),
          Text("   C°", style: TextStyle(fontWeight: FontWeight.bold)),
        ],);     
      },
    ); 
  }
}
