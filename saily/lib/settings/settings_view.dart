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
          SwitchSettingsTile(
            settingKey: 'follow-map-rotation',
            title: 'Follow Map Rotation',
            subtitle: 'The map will rotate according to gps rotation',
            enabledLabel: 'Enabled',
            disabledLabel: 'Disabled',
            defaultValue: false,
            leading: Icon(Icons.rotate_90_degrees_ccw_outlined),
            onChange: (value) async {
              final val = await settingsController.getFollowMapRotationValue();
              debugPrint("Stored Follow Map Rotation: $val");
            },
          ),
          SwitchSettingsTile(
            settingKey: 'expand-tile',
            title: 'Expand Tile',
            subtitle:
                'The map will move the cursor according to the expande tile below',
            enabledLabel: 'Enabled',
            disabledLabel: 'Disabled',
            defaultValue: false,
            leading: Icon(Icons.expand_more_outlined),
            onChange: (value) async {
              settingsController.updateExpandTile(value);
            },
          ),
          // SliderSettingsTile(
          //   leading: Icon(Icons.roller_shades),
          //   title: "Map Fake Offset", settingKey: "map-fake-offset", min: 0, max: 0.05, step: 0.01,
          //   onChange: (value){
          //     settingsController.updateCurrentMapFakeOffset(value);
          //   },)
        ]),
      ]),
      // Settings
    );
  }
}
