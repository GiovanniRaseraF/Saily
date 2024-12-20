// Actual app
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:saily/settings/settings_controller.dart';
import 'package:saily/utils/saily_colors.dart';

class SettingsView extends StatefulWidget {
  SettingsView({super.key, required this.settingsController});

  final String title = "settings";
  SettingsController settingsController;

  @override
  State<SettingsView> createState() =>
      _SettingsViewState(settingsController: settingsController);
}

class _SettingsViewState extends State<SettingsView> {
  _SettingsViewState({required this.settingsController});

  SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SettingsScreen(hasAppBar: true, children: [
        SettingsGroup(title: 'Map Setting', children: <Widget>[
          Card(
            child: SwitchSettingsTile(
              settingKey: 'expand-tile',
              title: 'Expand Tile',
              subtitle:
                  'The map will move the cursor according to the expande tile below',
              defaultValue: false,
              onChange: (value) async {
                settingsController.updateExpandTile(value);
              },
            ),
          ),

        SettingsGroup(title: 'Telemetry Units', children: <Widget>[
          DropDownSettingsTile<String>(
            title: "SOG Unit", 
            subtitle: "Speed over gournd calculated using gps",
            settingKey: "sog-unit", selected: "km/h", values: {"km/h": "km/h", "knt" : "knt"},
            onChange: (value){
              settingsController.sendSogUnit(value);
            },
            ),
          DropDownSettingsTile<String>(
            title: "MotorTemp Unit", 
            subtitle: "Motor temperature average read with NMEA2000",
            settingKey: "motor-temp-unit", selected: "C", values: {"C": "C", "F" : "F", "K": "K"},
            onChange: (value){
              settingsController.setMotorTempUnit(value);
            },
            ),
        ]),
        ]),
      ]),
      // Settings
    );
  }
}
