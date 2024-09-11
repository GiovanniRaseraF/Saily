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
      _RecordViewState();
}

class _RecordViewState extends State<RecordView> {
  _RecordViewState() {}

  @override
  Widget build(BuildContext context) {
    return Container(
      width: gCtxW() * 0.3,
      
      child: FloatingActionButton(
        onPressed: () {
          if (widget.recordController.isRecording()) {
            String selectedName = "";
              // return 
              dialogCreator(
                context,
                // change name
                (value) {selectedName = value;},
                // on presed save
                (){
                  widget.recordController.cancelTimer();
                  widget.recordController.stopRecording();
                  widget.settingsController.saveRecorderPositions(
                      selectedName, widget.recordController.getFrom());
                  widget.settingsController.resetRecorderPositions();
                  widget.recordController.restoreIntenalTime();
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
            widget.recordController.restoreIntenalTime();
            widget.recordController.setFrom(DateTime.now().toString());
            print("START recording");
            widget.recordController.startRecording();
            widget.recordController.startTimer((){if(mounted) setState(() {});});
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
          TimerDisplay(seconds: widget.recordController.getInternalTime())
        ]),
      ),
    );
  }

 static void dialogCreator(
      BuildContext c,
      void Function(String) onChangedNameTextField,
      void Function() onPressedNewBoat,
      void Function() onPressedContinue) {
    // create a dialog
    showDialog<String>(
      context: c,
      builder: (BuildContext context) => Dialog(
        child: SaveRouteDialog(
          onChangedNameTextField: onChangedNameTextField,
          onPressedNewBoat: onPressedNewBoat,
          onPressedContinue: onPressedContinue,
        )));
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

    String minss = (mins < 10 ? " " : "") + "${mins} min";
    String minunes = (mins < 10 ? " " : "") + "${mins} min";

    String secs = (sec < 10 ? " " : "") + "${sec} sec";
    return Text("${minss} ${secs}");
  }
}
