import 'dart:async';
import 'dart:math';

import 'package:dart_either/src/dart_either.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:saily/datatypes/actuator_info.dart';
import 'package:saily/datatypes/boat_info.dart';
import 'package:saily/datatypes/electricmotor_info.dart';
import 'package:saily/datatypes/endotermicmotor_info.dart';
import 'package:saily/datatypes/general_info.dart';
import 'package:saily/datatypes/highpowerbattery_info.dart';
import 'package:saily/datatypes/nmea2000_info.dart';
import 'package:saily/main.dart';
import 'package:saily/server/server.dart';
import 'package:saily/settings/settings_controller.dart';
import 'package:saily/tracks/fake_data.dart';
import 'package:saily/tracks/gpx_trips.dart';
import 'package:saily/utils/utils.dart';

class StewardServerInfo extends Server{
  StewardServerInfo({required this.settingsController}){
    runFetchProcess(interval: Duration(seconds: 10), callback: fetchProcess);
  }

  String serverIp = "89.36.209.139";

  SettingsController settingsController;

  void fetchProcess(Timer t){
    print("Running fetch..");
  }

  Future<Either<InitError, String>> initServer() async {
    throw UnimplementedError();
    return Either.left(InitError(why: "initServer is abstract"));
  } 

  @override
  Future<Either<FetchError, ActuatorInfo>> fetchAcuatorInfo() {
    // TODO: implement fetchAcuatorInfo
    throw UnimplementedError();
  }

  @override
  Future<Either<FetchError, List<BoatInfo>>> fetchBoats() {
    // TODO: implement fetchBoatInfo
    throw UnimplementedError();
  }

  @override
  Future<Either<FetchError, ElectricmotorInfo>> fetchElectricmotorInfo() {
    // TODO: implement fetchElectricmotorInfo
    throw UnimplementedError();
  }

  @override
  Future<Either<FetchError, EndotermicmotorInfo>> fetchEndotermicmotorInfo() {
    // TODO: implement fetchEndotermicmotorInfo
    throw UnimplementedError();
  }

  @override
  Future<Either<FetchError, GeneralInfo>> fetchGeneralInfo() {
    // TODO: implement fetchGeneralInfo
    throw UnimplementedError();
  }

  @override
  Future<Either<FetchError, HighpowerbatteryInfo>> fetchHighpowerbatteryInfo() {
    // TODO: implement fetchHighpowerbatteryInfo
    throw UnimplementedError();
  }

  @override
  Future<Either<FetchError, VTGInfo>> fetchVTGInfo() {
    // TODO: implement fetchVTGInfo
    throw UnimplementedError();
  }

    // returns true if the creadentials are good
  Future<bool> canUserLogin(String username, String password) async {
    return false;
  }

  // returns the the list of boats
  Future<List<BoatInfo>> boatsList(String username, String password) async {
    return [];
  }

  @override
  void runFetchProcess({required Duration interval, required void Function(Timer p1) callback}) {
    fetch = Timer.periodic(interval, callback);
  }

  @override
  void stopFetchProcess() {
    fetch.cancel();
  }
}