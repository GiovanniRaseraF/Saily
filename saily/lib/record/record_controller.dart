import 'dart:async';

import 'package:flutter/material.dart';
import 'package:saily/settings/settings_controller.dart';
import 'package:saily/utils/saily_colors.dart';
import 'package:saily/utils/saily_utils.dart';
import 'package:latlong2/latlong.dart';

class RecordController {
  RecordController({required this.settingsController}){
    mapPositioning = settingsController.getCurrentBoatPositionStream();
    mapPositioning.listen((data) {
      if (recording) {
        settingsController.addPositionToRecordedPositions(data);
      }
    });
  }

  SettingsController settingsController;
  bool recording = false;
  String from = "";

  late Timer timeout;
  int internalTime = 0;

  late Stream<LatLng> mapPositioning;

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

  // Dialog creator
  static void dialogCreator(
      BuildContext context,
      void Function(String) onChangedNameTextField,
      void Function() onPressedNewBoat,
      void Function() onPressedContinue) {
    // create a dialog
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: Container(
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
                    onChanged: onChangedNameTextField,
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
                      onPressed: onPressedNewBoat,
                    )),
                Divider(
                  color: Colors.transparent,
                ),
                Divider(
                  color: Colors.transparent,
                ),
                TextButton(
                  onPressed: onPressedContinue,
                  child: const Text('Continue'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
