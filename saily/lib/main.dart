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
import 'package:saily/widgets/power_gauge.dart';
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
  // debug send gps
  send = Timer.periodic(Duration(milliseconds: 500), (t) {
    // gps positioning
    settingsController.updateCurrentBoatPosition(fakeData.getNext());

    // gps count
    bool isFixed = Random().nextBool();
    int count = Random().nextInt(10);
    final gpsCount = GpsInfo(
        isFixed: isFixed,
        satellitesCount: count,
        SOG: Random().nextDouble() * 100);
    settingsController.updateCurrentGpsCounter(gpsCount);

    // battery info
    BatteryInfo batteryInfo = BatteryInfo(
        SOC: Random().nextInt(100),
        voltage: Random().nextDouble() * 80,
        power: Random().nextDouble(),
        temp: Random().nextDouble() * 80);
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
              left: scaleW(context, 0.05),
              child: OrientationBuilder(builder: (context, orientation) {
                //print("scaleW: ${scaleW(context, 0.90)}");
                var w = scaleW(context, 0.90);
                var h = scaleH(context, 0.40);
                return ExpandableTile(
                    collapsed: SizedBox(
                        width: w,
                        height: h / 3.5,
                        child: Card(
                          color: SailyWhite,
                          elevation: 10,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    SOGGauge(
                                        settingsController: settingsController,
                                        small: true),
                                    PowerGauge(
                                        settingsController: settingsController,
                                        small: true),
                                    FuelGauge(
                                        settingsController: settingsController,
                                        small: true),
                                  ]),
                            ],
                          ),
                        )),
                    expanded: SizedBox(
                        width: w,
                        height: h,
                        child: Card(
                          color: SailyWhite,
                          child: SingleChildScrollView(
                            child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
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
                                  Divider(),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        SOGGauge(
                                            settingsController:
                                                settingsController,
                                            small: false),
                                        SOCGauge(
                                            settingsController:
                                                settingsController,
                                            small: false),
                                      ]),
                                  Divider(),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        VoltageGauge(
                                            settingsController:
                                                settingsController,
                                            small: false),
                                        MotorTempGauge(
                                            settingsController:
                                                settingsController,
                                            small: false),
                                      ]),
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
