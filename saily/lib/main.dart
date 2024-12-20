/*
author: Giovanni Rasera
*/

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:saily/datatypes/electricmotor_info.dart';
import 'package:saily/datatypes/highpowerbattery_info.dart';
import 'package:saily/datatypes/user_info.dart';
import 'package:saily/login/login_view.dart';
import 'package:saily/record/record_controller.dart';
import 'package:saily/record/record_view.dart';
import 'package:saily/routes/routes_view.dart';
import 'package:saily/server/fake_server.dart';
import 'package:saily/server/huracan_server.dart';
import 'package:saily/server/mock_server.dart';
import 'package:saily/server/server.dart';
import 'package:saily/settings/local_store.dart';
import 'package:saily/tracks/gpx_trips.dart';
import 'package:saily/user/user_view.dart';
import 'package:saily/datatypes/nmea2000_info.dart';
import 'package:saily/env.dart';
import 'package:saily/settings/settings_controller.dart';
import 'package:saily/settings/settings_service.dart';
import 'package:saily/settings/settings_view.dart';
import 'package:saily/utils/saily_utils.dart';
import 'package:saily/utils/utils.dart';
import 'package:saily/widgets/connection_to_server_status_gauge.dart';
import 'package:saily/widgets/fuel_gauge.dart';
import 'package:saily/widgets/microdivider_widget.dart';
import 'package:saily/widgets/power_gauge.dart';
import 'package:saily/widgets/temps/bmstemp_gauge.dart';
import 'package:saily/widgets/temps/motortemp_gauge.dart';
import 'package:saily/widgets/temps/powertemp_gauge.dart';
import 'package:saily/widgets/soc_gauge.dart';
import 'package:saily/widgets/sog_gauge.dart';
import 'package:saily/widgets/expandable_tile.dart';
import 'package:saily/widgets/temps/batterytemp_gauge.dart';
import 'package:saily/utils/saily_colors.dart';
import 'package:saily/map/map_view.dart';
import 'package:saily/widgets/main_gauge.dart';
import 'package:saily/widgets/speed_gauge.dart';
import 'package:saily/widgets/voltage_gauge.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences sharedPreferences;
late SettingsController settingsController;
late SettingsService settingsService;
late RecordController recordController;

// expanded at start
late bool expandedatstart;

// Server
late Server server;

// Local Store
late LocalStore localStore;

void main() async {
  await WidgetsFlutterBinding.ensureInitialized();

  // setting init
  sharedPreferences = await SharedPreferences.getInstance();

  // Local Store init
  localStore = LocalStore(preferences: sharedPreferences);
  localStore.loadUsers();  

  // setting service
  settingsService = SettingsService(sharePreferences: sharedPreferences, localStore: localStore);
  settingsController = SettingsController(settingsService: settingsService);

  await settingsController.loadDependeces();
  recordController = RecordController(settingsController: settingsController);

  await Settings.init(cacheProvider: settingsService);

  ///////////////////////////////////////////////////////////////////
  // Connect to server

  // Used in production
  //server = HuracanServer(settingsController: settingsController);

  // (sed in testing
  MockServerStore store = MockServerStore(preferences: sharedPreferences);
  await store.loadRoats();
  server = MockServer(settingsController: settingsController, store: store);

  // Init it
  await server.initServer();
  ///////////////////////////////////////////////////////////////////

  // Prelogging
  String u = settingsController.getUsername();
  String p = settingsController.getPassword();

  bool canLogin = await server.canUserLogin(u, p);
  print("can login: $canLogin");

  if (!canLogin) {
    print("User $u, $p does not exist");
  } else {
    settingsController.login(u, p);
  }

  // load settings
  expandedatstart = false;

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
        home: LoginView(settingsController: settingsController, onLogin: () {}, server: server));
  }
}

// Actual app
class MyHomePage extends StatefulWidget {
  MyHomePage(
      {super.key,
      required this.title,
      required this.settingsController,
      required this.onLogout,
      required this.server
      });

  final String title;
  SettingsController settingsController;
  void Function() onLogout;
  Server server;

  @override
  State<MyHomePage> createState() => _MyHomePageState(
      settingsController: settingsController, onLogout: onLogout, server: server);
}

class _MyHomePageState extends State<MyHomePage> {
  _MyHomePageState({required this.settingsController, required this.onLogout, required this.server});
  SettingsController settingsController;
  Server server;
  void Function() onLogout;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(builder: (c, or) {
          if (or == Orientation.landscape) {
            var w = scaleW(c, 1);
            var h = scaleH(c, 0.45);
            return Scaffold(
              body: Stack(children: [
                // Map
                MapView(
                  settingsController: settingsController,
                ),
        
                // main menu
                Positioned(
                  bottom: scaleH(c, 0.0),
                  left: 0,
                  child: Hero(
                      transitionOnUserGestures: true,
                      tag: "expandable-main",
                      child: SizedBox(
                        width: w / 2.4,
                        height: h * 1.7,
                        child: SingleChildScrollView(
                          child: Column(children: [
                            SizedBox(
                              width: w,
                              child: Card(
                                elevation: 10,
                                color: SailyWhite,
                                child: Center(
                                  child: Stack(children: [
                                    MainGauge(
                                        settingsController: settingsController,
                                        small: false),
                                  ]),
                                ),
                              ),
                            ),
                            Card(
                              elevation: 10,
                              color: SailyWhite,
                              child: Column(
                                children: [
                                  Div(Colors.transparent, 10),
                                  PowerTempGauge(
                                      settingsController: settingsController,
                                      small: false),
                                  Div(Colors.transparent, 10),
                                  MotorTempGauge(
                                      settingsController: settingsController,
                                      small: false),
                                  Div(Colors.transparent, 10),
                                  BatteryTempGauge(
                                      settingsController: settingsController,
                                      small: false),
                                  Div(Colors.transparent, 10),
                                  BMSTempGauge(
                                      settingsController: settingsController,
                                      small: false),
                                  Div(Colors.transparent, 20),
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
                                            settingsController: settingsController,
                                            small: false),
                                      ]),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        PowerGauge(
                                            settingsController: settingsController,
                                            small: false),
                                        FuelGauge(
                                            settingsController: settingsController,
                                            small: false),
                                      ]),
                                ]))
                          ]),
                        ),
                      )),
                ),
        
                // side menu
                Positioned(
                  top: scaleH(context, 0.05),
                  right: scaleW(context, 0.04),
                  child: Row(
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
                                          server: server,
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
                    left: scaleW(context, 0.005),
                    child: RecordView(
                      settingsController: settingsController,
                      recordController: recordController,
                    )),
                // Online status
                Positioned(
                    top: scaleH(context, 0.06),
                    left: scaleW(context, 0.48),
                    child: ConnectionToServerStatusGauge(settings: settingsController)),
              ]),
            );
          }
        
          // portrait
          var w = scaleW(c, 1);
          var h = scaleH(c, 0.45);
          return Scaffold(
            body: Stack(children: [
              // Map
              MapView(
                settingsController: settingsController,
              ),
        
              // main menu
              Positioned(
                  bottom: scaleH(c, 0.0),
                  left: scaleW(c, 0.0),
                  child: ExpandableTile(
                      onCollapsedToExpanded: () async {
                        await server.fetchAll();
                        setState(() {});
                      },
                      onExpandedToCollapsed: () async {
                        await server.fetchAll();
                        setState(() {});
                      },
                      collapsed: Hero(
                        transitionOnUserGestures: true,
                        tag: "expandable-main",
                        child: SizedBox(
                          width: w,
                          child: Card(
                            elevation: 10,
                            color: SailyWhite,
                            child: Center(
                              child: Stack(children: [
                                MainGauge(
                                    settingsController: settingsController,
                                    small: false),
                              ]),
                            ),
                          ),
                        ),
                      ),
                      expanded: Hero(
                          transitionOnUserGestures: true,
                          tag: "expandable-main",
                          child: SizedBox(
                            width: w,
                            height: h,
                            child: SingleChildScrollView(
                              child: Column(children: [
                                SizedBox(
                                  width: w,
                                  child: Card(
                                    elevation: 10,
                                    color: SailyWhite,
                                    child: Center(
                                      child: Stack(children: [
                                        MainGauge(
                                            settingsController: settingsController,
                                            small: false),
                                      ]),
                                    ),
                                  ),
                                ),
                                Card(
                                  elevation: 10,
                                  color: SailyWhite,
                                  child: Column(
                                    children: [
                                      Div(Colors.transparent, 10),
                                      PowerTempGauge(
                                          settingsController: settingsController,
                                          small: false),
                                      Div(Colors.transparent, 10),
                                      MotorTempGauge(
                                          settingsController: settingsController,
                                          small: false),
                                      Div(Colors.transparent, 10),
                                      BatteryTempGauge(
                                          settingsController: settingsController,
                                          small: false),
                                      Div(Colors.transparent, 10),
                                      BMSTempGauge(
                                          settingsController: settingsController,
                                          small: false),
                                      Div(Colors.transparent, 20),
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
                      settingsController: settingsController)),
        
              // side menu
              Positioned(
                top: scaleH(c, 0.05),
                right: scaleW(c, 0.04),
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
                                        server: server,
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
              // Online status
              Positioned(
                  top: scaleH(context, 0.06),
                  left: scaleW(context, 0.48),
                  child: ConnectionToServerStatusGauge(settings: settingsController)),
            ]),
          );
        });
      }
    );
  }
}
