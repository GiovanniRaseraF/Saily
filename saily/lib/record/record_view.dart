// Actual app
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:saily/routes/route_widget.dart';
import 'package:saily/settings/settings_controller.dart';
import 'package:saily/user/boat_widget.dart';
import 'package:saily/utils/saily_utils.dart';
import 'package:saily/utils/saily_colors.dart';
import 'package:saily/widgets/microdivider_widget.dart';
import 'package:latlong2/latlong.dart';

class RecordView extends StatefulWidget {
  RecordView({super.key, required this.settingsController});

  final String title = "routes";
  SettingsController settingsController;

  @override
  State<RecordView> createState() =>
      _RecordViewState(settingsController: settingsController);
}

class _RecordViewState extends State<RecordView> {
  _RecordViewState({required this.settingsController}) {
    mapPositioning = settingsController.getCurrentBoatPositionStream();
    mapPositioning!.listen((data) {
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

  late Stream<LatLng>? mapPositioning;

  // Add one second to the timer
  void addOneSecond() {
    internalTime++;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: gCtxW() * 0.3,
      child: FloatingActionButton(
        onPressed: () {
          if (recording) {
            String selectedName = "";
            
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
                        Divider(color: Colors.transparent,),
                        SizedBox(
                          child: TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Name',
                            ),
                            onChanged: (value) {
                              selectedName = value;
                            },
                          ),
                        ),
                        Divider(color: Colors.transparent,),
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
                                onPressed: () {
                                  timeout.cancel();
                                  print("STOP recording ${internalTime} s");
                                  recording = false;
                                  settingsController.saveRecorderPositions(
                                      selectedName, from);
                                  settingsController.resetRecorderPositions();
                                  internalTime = 0;
                                  setState(() {});
                                  Navigator.pop(context);
                                })),
                        Divider(color: Colors.transparent,),
                        Divider(color: Colors.transparent,),
                        TextButton(
                          onPressed: () {
                            print("CONTINUE recording");
                            Navigator.pop(context);
                          },
                          child: const Text('Continue'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else {
            internalTime = 0;
            from = DateTime.now().toString();
            print("START recording");
            recording = true;
            timeout = Timer.periodic(Duration(seconds: 1), (t) {
              addOneSecond();
            });
          }
        },
        backgroundColor: Colors.white,
        child: Row(children: [
          MicrodividerWidgetd(height: 0),
          Icon(
            Icons.emergency_recording,
            color: Colors.red,
          ),
          MicrodividerWidgetd(height: 0),
          MicrodividerWidgetd(height: 0),
          MicrodividerWidgetd(height: 0),
          TimerDisplay(seconds: internalTime)
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
