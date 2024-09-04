// Actual app
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:saily/record/record_controller.dart';
import 'package:saily/routes/route_widget.dart';
import 'package:saily/settings/settings_controller.dart';
import 'package:saily/user/boat_widget.dart';
import 'package:saily/utils/saily_utils.dart';
import 'package:saily/utils/saily_colors.dart';
import 'package:saily/widgets/microdivider_widget.dart';
import 'package:latlong2/latlong.dart';

class RecordView extends StatefulWidget {
  RecordView({super.key, required this.settingsController, required this.recordController});

  final String title = "routes";
  SettingsController settingsController;
  RecordController recordController;

  @override
  State<RecordView> createState() =>
      _RecordViewState(settingsController: settingsController, recordController: recordController);
}

class _RecordViewState extends State<RecordView> {
  _RecordViewState({required this.settingsController, required this.recordController}) {}

  RecordController recordController;
  SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: gCtxW() * 0.3,
      child: FloatingActionButton(
        onPressed: () {
          if (recordController.isRecording()) {
            String selectedName = "";

            // dialog creator
            RecordController.dialogCreator(
              context,
              // change name
              (value) {selectedName = value;},
              // on presed save
              (){
                recordController.cancelTimer();
                recordController.stopRecording();
                settingsController.saveRecorderPositions(
                    selectedName, recordController.getFrom());
                settingsController.resetRecorderPositions();
                recordController.restoreIntenalTime();
                setState(() {});
                Navigator.pop(context);
              },
              // on presed continue
              (){
                print("CONTINUE recording");
                Navigator.pop(context);
              }
            );
  
          } else {
            recordController.restoreIntenalTime();
            recordController.setFrom(DateTime.now().toString());
            print("START recording");
            recordController.startRecording();
            recordController.startTimer((){if(mounted) setState(() {});});
            // timeout = Timer.periodic(Duration(seconds: 1), (t) {
            //   addOneSecond();
            // });
          }
        },
        backgroundColor: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(
            Icons.emergency_recording,
            color: Colors.red,
          ),
          TimerDisplay(seconds: recordController.getInternalTime())
        ]),
      ),
    );
  }
}

// displays the intenal time as 00:00
class TimerDisplay extends StatelessWidget {
  TimerDisplay({required this.seconds});
  int seconds;
  @override
  Widget build(BuildContext context) {
    int mins = (seconds / 60).toInt();
    int sec = (seconds % 60);

    String minss = (mins < 10 ? "0" : "") + "${mins}";
    String minunes = (mins < 10 ? "0" : "") + "${mins}";

    String secs = (sec < 10 ? "0" : "") + "${sec}";
    return Text("${minss}:${secs}");
  }
}
