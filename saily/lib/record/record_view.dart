// Actual app
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

  @override
  Widget build(BuildContext context) {
    return 
    Container(
      width: gCtxW() * 0.3,
      child: FloatingActionButton(
        onPressed: () {
          print("Start recording");
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
          Text("00:00")
        ]),
      ),
    );
  }
}
