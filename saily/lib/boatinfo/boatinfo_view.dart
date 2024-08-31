// Actual app
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:saily/settings/settings_controller.dart';
import 'package:saily/utils/utils.dart';
import 'package:saily/utils/hm_colors.dart';

class BoatInfoView extends StatefulWidget {
  BoatInfoView({super.key, required this.settingsController});

  final String title = "user";
  SettingsController settingsController;

  @override
  State<BoatInfoView> createState() =>
      _BoatInfoViewState(settingsController: settingsController);
}

class _BoatInfoViewState extends State<BoatInfoView> {
  _BoatInfoViewState({required this.settingsController});

  SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:
          
            SettingsScreen(hasAppBar: true, title: "User", children: []));
  }
}
