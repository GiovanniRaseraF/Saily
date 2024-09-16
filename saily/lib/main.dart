import 'dart:async';
import 'dart:collection';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:saily/datatypes/boat_info.dart';
import 'package:saily/datatypes/user_info.dart';
import 'package:saily/login/login_view.dart';
import 'package:saily/record/record_controller.dart';
import 'package:saily/record/record_view.dart';
import 'package:saily/routes/routes_view.dart';
import 'package:saily/settings/fake_server.dart';
import 'package:saily/tracks/gpx_trips.dart';
import 'package:saily/user/user_view.dart';
import 'package:saily/datatypes/battery_info.dart';
import 'package:saily/datatypes/gps_info.dart';
import 'package:saily/env.dart';
import 'package:saily/settings/settings_controller.dart';
import 'package:saily/settings/settings_service.dart';
import 'package:saily/settings/settings_view.dart';
import 'package:saily/tracks/fake_data.dart';
import 'package:saily/utils/saily_utils.dart';
import 'package:saily/utils/utils.dart';
import 'package:saily/widgets/fuel_gauge.dart';
import 'package:saily/widgets/microdivider_widget.dart';
import 'package:saily/widgets/power_gauge.dart';
import 'package:saily/widgets/powertemp_gauge.dart';
import 'package:saily/widgets/soc_gauge.dart';
import 'package:saily/widgets/expandable_tile.dart';
import 'package:saily/widgets/gps_counter.dart';
import 'package:saily/widgets/motortemp_gauge.dart';
import 'package:latlong2/latlong.dart';
import 'package:saily/utils/saily_colors.dart';
import 'package:saily/map/map_view.dart';
import 'package:saily/widgets/sog_gauge.dart';
import 'package:saily/widgets/voltage_gauge.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences sharedPreferences;
late SettingsController settingsController;
late SettingsService settingsService;
late RecordController recordController;

// expanded at start
late bool expandedatstart;

late Timer send;
FakeData fakeData = FakeData();

// login
late FakeServer fakeServer;

void createDebug() async {
  fakeData.load_parse(cannesTrip);
  double SOG = 0;
  double SOC = 0;
  // debug send gps
  send = Timer.periodic(Duration(milliseconds: (200)), (t) {
    // gps positioning
    settingsController.updateCurrentBoatPosition(fakeData.getNext());

    // gps count
    bool isFixed = Random().nextBool();
    int count = Random().nextInt(10);
    final gpsCount =
        GpsInfo(isFixed: isFixed, satellitesCount: count, SOG: SOG % 150);
    settingsController.updateCurrentGpsCounter(gpsCount);
    SOG += 10;
    // battery info
    BatteryInfo batteryInfo = BatteryInfo(
        SOC: (SOC++ % 100).toInt(),
        voltage: Random().nextDouble() * 80,
        power: SOG,
        temp: 80);
    settingsController.updateBatteryInfo(batteryInfo);
  });
}

void main() async {
  await WidgetsFlutterBinding.ensureInitialized();
  // setting init
  sharedPreferences = await SharedPreferences.getInstance();
  // server for login
  fakeServer = FakeServer(preferences: sharedPreferences);
  fakeServer.loadUsers();
  fakeServer.updateUser(UserInfo(
      email: "ciao@hello.com",
      username: "admin2",
      password: "admin2",
      boats: [],
      routes: []));

  // setting service
  settingsService =
      SettingsService(sharePreferences: sharedPreferences, server: fakeServer);
  settingsController = SettingsController(settingsService: settingsService);
  await settingsController.loadDependeces();
  recordController = RecordController(settingsController: settingsController);

  await Settings.init(
    cacheProvider: settingsService,
  );

  createDebug();
  debugPrint(settingsService.getKeys().toString());
  debugPrint(Env.str());

  // load settings
  expandedatstart = false;

  debugPrint("$expandedatstart");

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    setGlobalContext(context);
    return MaterialApp(
        title: 'Saily',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: SailyBlue),
          useMaterial3: true,
        ),
        home:
            LoginView(settingsController: settingsController, onLogin: () {}));
  }
}

// Actual app
class MyHomePage extends StatefulWidget {
  MyHomePage(
      {super.key,
      required this.title,
      required this.settingsController,
      required this.onLogout});

  final String title;
  SettingsController settingsController;
  void Function() onLogout;

  @override
  State<MyHomePage> createState() => _MyHomePageState(
      settingsController: settingsController, onLogout: onLogout);
}
//

class _MyHomePageState extends State<MyHomePage> {
  _MyHomePageState({required this.settingsController, required this.onLogout});
  SettingsController settingsController;
  void Function() onLogout;
  @override
  Widget build(BuildContext context) {
    return NotificationListener<SizeChangedLayoutNotification>(
      onNotification: (notification) {
        print(scaleW(context, 1));
        return true;
      },
      child: Scaffold(
        body: Stack(children: [
          // Map
          MapView(
            settingsController: settingsController,
          ),

          // main menu
          Positioned(
              bottom: scaleH(context, 0.01),
              left: scaleW(context, 0.002),
              child: OrientationBuilder(builder: (context, orientation) {
                var w = scaleW(context, 0.999);
                var h = scaleH(context, 0.45);
                return ExpandableTile(
                    collapsed: Center(
                      child: FittedBox(
                        fit: BoxFit.fill,
                          child: SizedBox(
                            width: w,
                            height: h / 2.3,
                            child: Card(
                              color: Colors.transparent,
                              child:  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Center(
                                        child: Card(
                                          elevation: 10,
                                          color: SailyWhite,
                                          child: Center(
                                            child: SOCGauge(
                                                settingsController:
                                                    settingsController,
                                                small: false),
                                          ),
                                        ),
                                      ),
                                      ]),
                                                  
                              ),
                          ),
                          ),
                    ),
                    expanded: SizedBox(
                        width: w,
                        height: h,
                        child: Card(
                          color: Colors.transparent,
                          child: SingleChildScrollView(
                            child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Center(
                                    child: Card(
                                      elevation: 10,
                                      color: SailyWhite,
                                      child: Center(
                                        child: SOCGauge(
                                            settingsController:
                                                settingsController,
                                            small: false),
                                      ),
                                    ),
                                  ),
                                  Card(
                                    elevation: 10,
                                    color: SailyWhite,
                                    child: Column(
                                      children: [
                                        Divider(
                                          color: Colors.transparent,
                                        ),
                                        PowerTempGauge(
                                            settingsController:
                                                settingsController,
                                            small: false),
                                        Divider(
                                          color: Colors.transparent,
                                        ),
                                        MotorTempGauge(
                                            settingsController:
                                                settingsController,
                                            small: false),
                                        Divider(
                                          color: Colors.transparent,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Card(
                                      elevation: 10,
                                      color: SailyWhite,
                                      child: Column(children: [
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              VoltageGauge(
                                                  settingsController:
                                                      settingsController,
                                                  small: false),
                                            ]),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              PowerGauge(
                                                  settingsController:
                                                      settingsController,
                                                  small: false),
                                              FuelGauge(
                                                  settingsController:
                                                      settingsController,
                                                  small: false),
                                            ]),
                                      ]))
                                ]),
                          ),
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
                    height: scaleH(context, 0.001),
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
                    mini: true,
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
                                    settingsController: settingsController,
                                    onLogout: () {
                                      //Navigator.pop(context);
                                      this.onLogout();
                                    },
                                  )),
                        );
                      },
                      mini: true,
                      backgroundColor: SailyWhite,
                      elevation: 100,
                      child:
                          Icon(color: SailyBlue, Icons.account_box_outlined)),
                  SizedBox(
                    height: scaleH(context, 0.05),
                  ),
                  FloatingActionButton(
                    heroTag: "routes",
                    mini: true,
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
                ]),
          ),
          Positioned(
              top: scaleH(context, 0.05),
              left: scaleW(context, 0.04),
              child: RecordView(
                settingsController: settingsController,
                recordController: recordController,
              )),
        ]),
      ),
    );
  }
}
