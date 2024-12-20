import 'dart:async';

import 'package:flutter/material.dart';
import 'package:saily/datatypes/electricmotor_info.dart';
import 'package:saily/datatypes/highpowerbattery_info.dart';
import 'package:saily/datatypes/nmea2000_info.dart';
import 'package:saily/settings/settings_controller.dart';
import 'package:saily/utils/saily_colors.dart';
import 'package:saily/utils/saily_utils.dart';
import 'package:latlong2/latlong.dart';

class RecordController {
  RecordController({required this.settingsController}){
    mapPositioning = settingsController.getCurrentBoatPositionStream();
    hpibInfoStream = settingsController.getHighPowerBatteryInfoStream();
    emInfoStream = settingsController.getElectricMotorInfoStream();
    vtgInfoStream = settingsController.getNVTGStream();

    mapPositioning.listen((data) {
      if (recording) {
        settingsController.addPositionToRecordedPositions(data);
      }
    });

    hpibInfoStream.listen((data) {
      if (recording) {
        settingsController.addPositionToRecordedHpbi(data);
      }
    });

    emInfoStream.listen((data) {
      if (recording) {
        settingsController.addPositionToRecordedEmi(data);
      }
    });

    vtgInfoStream.listen((data) {
      if (recording) {
        settingsController.addPositionToRecordedVtgi(data);
      }
    });
  }

  SettingsController settingsController;
  bool recording = false;
  String from = "";

  late Timer timeout;
  int internalTime = 0;

  late Stream<LatLng> mapPositioning;
  late Stream<HighpowerbatteryInfo> hpibInfoStream;
  late Stream<ElectricmotorInfo> emInfoStream;
  late Stream<VTGInfo> vtgInfoStream;

  // timer
  void startTimer(void Function() callback){
    timeout = Timer.periodic(Duration(seconds: 1), (t) {
      addOneSecond(callback);
    });  
  }

  void cancelTimer(){
    timeout.cancel();
  }

  // from 
  String getFrom(){
    return from;
  }

  void setFrom(String f){
    from = f;
  }

  // recording
  void startRecording(){
    setRecording(true);
  }

  void stopRecording(){
    setRecording(false);
  }

  void setRecording(bool rec){
    recording = rec;
  }

  bool isRecording(){
    return recording;
  }

  // internal time
  void restoreIntenalTime(){
    internalTime = 0;
  }

  int getInternalTime(){
    return internalTime;
  }

  // Add one second to the timer
  void addOneSecond( void Function() onSecondPassed){
    internalTime++;
    onSecondPassed();
  }
}

class SaveRouteDialog extends StatefulWidget {
  SaveRouteDialog({super.key, required this.onChangedNameTextField, required this.onPressedNewBoat, required this.onPressedContinue });

    void Function(String) onChangedNameTextField;
    void Function() onPressedNewBoat;
    void Function() onPressedContinue;

  @override
  State<SaveRouteDialog> createState() =>
      _SaveRouteDialogState();
}

class _SaveRouteDialogState extends State<SaveRouteDialog> {
  _SaveRouteDialogState();

      
  @override
  Widget build(BuildContext context) {

    return          
        Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Save Route',
                  style: TextStyle(fontSize: 20),
                ),
                Divider(
                  color: Colors.transparent,
                ),
                SizedBox(
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Name',
                    ),
                    onChanged: widget.onChangedNameTextField,
                  ),
                ),
                Divider(
                  color: Colors.transparent,
                ),
                SizedBox(
                    width: gCtxW() * 0.9,
                    child: FloatingActionButton(
                      heroTag: "add_new_boat",
                      child: Text(
                        "Save",
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: SailyBlue,
                      elevation: 10,
                      onPressed: widget.onPressedNewBoat,
                    )),
                Divider(
                  color: Colors.transparent,
                ),
                Divider(
                  color: Colors.transparent,
                ),
                TextButton(
                  onPressed: widget.onPressedContinue,
                  child: const Text('Continue'),
                ),
              ],
            ),
          ),
    );
  }

  
}


