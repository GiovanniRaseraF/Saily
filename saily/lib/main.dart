import 'dart:async';
import 'dart:collection';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:saily/record/record_view.dart';
import 'package:saily/routes/routes_view.dart';
import 'package:saily/tracks/gpx_trips.dart';
import 'package:saily/user/user_view.dart';
import 'package:saily/datatypes/battery_info.dart';
import 'package:saily/datatypes/gps_types.dart';
import 'package:saily/env.dart';
import 'package:saily/settings/settings_controller.dart';
import 'package:saily/settings/settings_service.dart';
import 'package:saily/settings/settings_view.dart';
import 'package:saily/tracks/fake_data.dart';
import 'package:saily/utils/saily_utils.dart';
import 'package:saily/utils/utils.dart';
import 'package:saily/widgets/soc_gauge.dart';
import 'package:saily/widgets/expandable_tile.dart';
import 'package:saily/widgets/gps_counter.dart';
import 'package:saily/widgets/motortemp_gauge.dart';
import 'package:latlong2/latlong.dart';
import 'package:saily/utils/saily_colors.dart';
import 'package:saily/map/map_view.dart';
import 'package:saily/widgets/sog_gauge.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences
    sharedPreferences; //= await SharedPreferences.getInstance();
late SettingsController settingsController; // = SettingsController();
late SettingsService settingsService; // = SettingsService(sharePreferences: );

// expanded at start
late bool expandedatstart;

late Timer send;
FakeData fakeData = FakeData();

void createDebug() async {
  fakeData.load_parse(cannesTrip);
  // debug send gps
  send = Timer.periodic(Duration(milliseconds: 500), (t) {
    // gps positioning
    settingsController.updateCurrentBoatPosition(fakeData.getNext());

    // gps count
    bool isFixed = Random().nextBool();
    int count = Random().nextInt(10);
    final gpsCount = GpsDataType(
        isFixed: isFixed,
        satellitesCount: count,
        SOG: Random().nextDouble() * 100);
    settingsController.updateCurrentGpsCounter(gpsCount);

    // battery info
    BatteryDataType batteryInfo = BatteryDataType(
        SOC: Random().nextInt(100),
        power: Random().nextDouble(),
        temp: Random().nextDouble() * 80);
    settingsController.updateBatteryInfo(batteryInfo);
  });
}

void main() async {
  await WidgetsFlutterBinding.ensureInitialized();
  // setting init
  sharedPreferences = await SharedPreferences.getInstance();
  settingsService = SettingsService(sharePreferences: sharedPreferences);
  settingsController = SettingsController(settingsService: settingsService);

  await Settings.init(
    cacheProvider: settingsService,
  );

  createDebug();
  debugPrint(settingsService.getKeys().toString());
  debugPrint(Env.str());

  // load settings
  expandedatstart = false; //= await settingsController.getExpandTileValue();

  debugPrint("$expandedatstart");

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Saily',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: SailyBlue),
        useMaterial3: true,
      ),
      home: MyHomePage(title: 'Saily'),
    );
  }
}

// Actual app
class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    setGlobalContext(context);
    return Scaffold(
      body: Stack(children: [
        // Map
        MapView(
          settingsController: settingsController,
        ),

        // main menu
        Positioned(
            bottom: scaleH(context, 0.01),
            left: scaleW(context, 0.05),
            child: OrientationBuilder(builder: (context, orientation) {
              //print("scaleW: ${scaleW(context, 0.90)}");
              var w = scaleW(context, 0.90);
              var h = scaleH(context, 0.40);
              return ExpandableTile(
                  leftTopComponent:
                      RecordView(settingsController: settingsController),
                  rightTopComponent: FloatingActionButton(
                    heroTag: "routes",
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RoutesView(
                                  settingsController: settingsController,
                                )),
                      );
                    },
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.route,
                      color: SailyBlue,
                    ),
                  ),
                  collapsed: SizedBox(
                      width: w,
                      height: h / 3.5,
                      child: Card(
                        color: SailyWhite,
                        elevation: 10,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SOGGauge(
                                  settingsController: settingsController,
                                  small: true),
                              SOCGauge(
                                  settingsController: settingsController,
                                  small: true),
                              SOCGauge(
                                  settingsController: settingsController,
                                  small: true),
                            ]),
                      )),
                  expanded: SizedBox(
                      width: w,
                      height: h,
                      child: Card(
                        color: SailyWhite,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    SOGGauge(
                                        settingsController: settingsController,
                                        small: false),
                                    SOCGauge(
                                        settingsController: settingsController,
                                        small: false),
                                  ]),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    SOCGauge(
                                        settingsController: settingsController,
                                        small: false),
                                    SOCGauge(
                                        settingsController: settingsController,
                                        small: false),
                                  ]),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    SOCGauge(
                                        settingsController: settingsController,
                                        small: false),
                                    SOCGauge(
                                        settingsController: settingsController,
                                        small: false),
                                  ]),
                            ]),
                      )),
                  header: Text("exp"),
                  expandedatstart: expandedatstart,
                  settingsController: settingsController);
            })),

        // side menu
        Positioned(
          top: scaleH(context, 0.05),
          right: scaleW(context, 0.04),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: scaleH(context, 0.01),
                ),
                FloatingActionButton(
                  heroTag: "settings",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SettingsView(
                                settingsController: settingsController,
                              )),
                    );
                  },
                  mini: false,
                  backgroundColor: SailyWhite,
                  elevation: 100,
                  child: Icon(color: SailyGrey, Icons.settings),
                ),
                SizedBox(
                  height: scaleH(context, 0.01),
                ),
                FloatingActionButton(
                    heroTag: "user",
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UserView(
                                settingsController: settingsController)),
                      );
                    },
                    mini: false,
                    backgroundColor: SailyWhite,
                    elevation: 100,
                    child: Icon(color: SailyBlue, Icons.account_box_outlined)),
                SizedBox(
                  height: scaleH(context, 0.05),
                ),
              ]),
        ),
      ]),
    );
  }
}
