import 'dart:async';
import 'dart:convert';

import 'package:dart_either/dart_either.dart';
import 'package:saily/datatypes/actuator_info.dart';
import 'package:saily/datatypes/boat_info.dart';
import 'package:saily/datatypes/electricmotor_info.dart';
import 'package:saily/datatypes/endotermicmotor_info.dart';
import 'package:saily/datatypes/general_info.dart';
import 'package:saily/datatypes/highpowerbattery_info.dart';
import 'package:saily/datatypes/nmea2000_info.dart';
import 'package:saily/server/server.dart';
import 'package:saily/settings/settings_controller.dart';
import 'package:http/http.dart';

class HuracanServer extends Server{
  HuracanServer({required this.settingsController});
  SettingsController settingsController;

  String USERNAME = "USERNAME";
  String PASSWORD = "PASSWORD";
  final DEFAULT_SERVER_NAME = "huracanpower.com";
  final DEFAULT_PORT = 443;

  Future<Either<InitError, String>> initServer() async {
    String loginData = "";

    try {
      final res = await post(
          Uri.parse("https://" + DEFAULT_SERVER_NAME + "/ping"),
          body: loginData,
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
          });

      final response = res.body;

      // checking response
      if (response.isEmpty) {
        return Either.left(InitError(why: "Response is empty"));
      } else {
        // parsing response
        final stringResult = response.toString();

        return Either.right(stringResult);
      }
    } on Exception catch (err) {
        return Either.left(InitError(why: err.toString()));
    }
  }

  Future<Either<FetchError, ActuatorInfo>> fetchAcuatorInfo() async {
    String loginData = "";

    try {
      final res = await post(
          Uri.parse("https://" + DEFAULT_SERVER_NAME + "/ping"),
          body: loginData,
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
          });

      final response = res.body;

      // checking response
      if (response.isEmpty) {
        return Either.left(FetchError(why: "Response is empty"));
      } else {
        // parsing response
        final stringResult = response.toString();
        final jsonValues = jsonDecode(stringResult);

        ActuatorInfo? res = ActuatorInfo.fromJSONDynamic(jsonValues);
        if(res == null) return Either.left(FetchError(why: "Cannot parse response: "+stringResult));
        return Either.right(res!);
      }
    } on Exception catch (err) {
        return Either.left(FetchError(why: err.toString()));
    }
  }

  // fetch boat information from server
  Future<Either<FetchError, BoatInfo>> fetchBoatInfo() async {
    throw "";
  }
  
  Future<Either<FetchError, ElectricmotorInfo>> fetchElectricmotorInfo() async {
    throw "";
  }

  Future<Either<FetchError, EndotermicmotorInfo>> fetchEndotermicmotorInfo() async {
    throw "";
  }
  
  Future<Either<FetchError, GeneralInfo>> fetchGeneralInfo() async {
    throw "";
  }

  Future<Either<FetchError, HighpowerbatteryInfo>> fetchHighpowerbatteryInfo() async {
    throw "";
  }

  Future<Either<FetchError, VTGInfo>> fetchVTGInfo() async {
    throw "";
  }

  void setFetchProcess({required Duration interval, required void Function(Timer) callback}){
    fetch = Timer.periodic(interval, callback);
  }

  void stopFetchProcess(){
    fetch.cancel();
  }
}