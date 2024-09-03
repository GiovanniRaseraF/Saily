// Actual app
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:saily/routes/route_widget.dart';
import 'package:saily/settings/settings_controller.dart';
import 'package:saily/user/boat_widget.dart';
import 'package:saily/utils/saily_utils.dart';
import 'package:saily/utils/utils.dart';
import 'package:saily/utils/saily_colors.dart';
import 'package:saily/widgets/microdivider_widget.dart';

class RecordView extends StatefulWidget {
  RecordView({super.key, required this.settingsController});

  final String title = "routes";
  SettingsController settingsController;

  @override
  State<RecordView> createState() =>
      _RecordViewState(settingsController: settingsController);
}

class _RecordViewState extends State<RecordView> {
  _RecordViewState({required this.settingsController});

  SettingsController settingsController;
  bool recording = false;

  late Timer timeout;
  int internalTime = 0;

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
            timeout.cancel();
            print("STOP recording ${internalTime} s");
            recording = false;

            // create a dialog
            showDialog<String>(
              context: context,
              builder: (BuildContext context) => Dialog(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text('Save Route'),
                      const SizedBox(height: 15),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Save'),
                      ),
                    ],
                  ),
                ),
              ),
            );

          } else {
            internalTime = 0;
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
