import 'package:flutter/material.dart';
import 'package:saily/server/server.dart';
import 'package:saily/settings/settings_controller.dart';
import 'package:saily/utils/saily_colors.dart';

class ConnectionToServerStatusGauge extends StatefulWidget {
  ConnectionToServerStatusGauge({required this.settings}) {}
  SettingsController settings;

  @override
  State<ConnectionToServerStatusGauge> createState() =>
      _ConnectionToServerStatusGaugeState(settings: settings);
}

class _ConnectionToServerStatusGaugeState
    extends State<ConnectionToServerStatusGauge> {
  _ConnectionToServerStatusGaugeState({required this.settings}) {}

  SettingsController settings;

  Widget build(BuildContext c) {
    return StreamBuilder(
        stream: settings.getConnectionToServerStatusStream(),
        builder: (bc, snapshot) {
          final data = snapshot.data;
          if (data == null) {
            return Icon(
              Icons.online_prediction,
              color: Colors.transparent,
            );
          }

          if (data == ConnectionToServerStatus.ONLINE) {
            return Icon(
              Icons.online_prediction,
              color: SailyBlue,
            );
          } else if (data == ConnectionToServerStatus.FETCH_ERROR) {
            return Icon(
              Icons.online_prediction,
              color: SailySuperRed,
            );
          } else {
            return Icon(
              Icons.online_prediction,
              color: Colors.transparent,
            );
          }
        });
  }
}
