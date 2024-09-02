import 'package:flutter/material.dart';
import 'package:saily/datatypes/gps_types.dart';
import 'package:saily/settings/settings_controller.dart';
import 'package:saily/utils/saily_colors.dart';

class GpsCounter extends StatefulWidget {
  GpsCounter({super.key, required this.settingsController});

  final String title = "gps_counter";
  SettingsController settingsController;

  @override
  State<GpsCounter> createState() =>
      _GpsCounterState(settingsController: settingsController);
}

class _GpsCounterState extends State<GpsCounter> {
  _GpsCounterState({required this.settingsController});

  SettingsController settingsController;
  IconData gpsFixIcon = Icons.gps_not_fixed;
  int count = 0;
  bool isFixed = false;

  // set fixed
  void setFixed(bool fixed) {
    if (fixed) {
      gpsFixIcon = Icons.gps_fixed_rounded;
    } else {
      gpsFixIcon = Icons.gps_not_fixed_rounded;
    }
    // done
    if (mounted) {
      //setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        heroTag: "gps_counter",
        onPressed: () {},
        mini: false,
        backgroundColor: SailyAlmostWhite,//Color.fromARGB(0, 255, 255, 255),
        elevation: 0,
        child: StreamBuilder(
            stream: settingsController.getCurrentGpsCounterStream(),
            builder: (bc, snapshot) {
              GpsDataType gpsCountType =
                  GpsDataType(isFixed: false, satellitesCount: 0, SOG: 0);

              // read data
              if (snapshot.data != null) {
                gpsCountType = snapshot.data!;
                count = gpsCountType.satellitesCount;
                isFixed = gpsCountType.isFixed;
              }
              // check fix
              setFixed(isFixed);

              if (isFixed) {
                return Column(children: [
                  Icon(color: SailyBlue, gpsFixIcon),
                  Text(style: TextStyle(color: SailyBlue), "$count")
                ]);
              } else {
                return Column(children: [
                  Icon(color: SailyOrange, gpsFixIcon),
                  Text(style: TextStyle(color: SailyOrange), "no gps")
                ]);
              }
            }));
  }
}
