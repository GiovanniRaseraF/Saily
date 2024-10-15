import 'dart:async';
import 'dart:convert';

import 'package:dart_either/dart_either.dart';
import 'package:flutter/material.dart';
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

class HuracanServer extends Server {
  HuracanServer({required this.settingsController}) {
    setFetchProcess(interval: Duration(seconds: 5), callback: fetchProcess);
  }
  SettingsController settingsController;

  String USERNAME = "g.rasera@huracanmarine.com";
  String PASSWORD = "MoroRacing2024";
  // final DEFAULT_SERVER_NAME = "huracanpower.com";
  // final DEFAULT_PORT = 443;
  // final PROTOCOL = "https";
  final DEFAULT_SERVER_NAME = "localhost";
  final DEFAULT_PORT = 8567;
  final PROTOCOL = "http";

  Future<void> fetchProcess(Timer t) async {
    print("-");
    print("--");
    print("---");
    print("-----");
    print("------");
    print("\n\n\nRunning fetch..");

    // init with ping
    final resPing = (await ping());
    final valPing = resPing.getOrHandle((err) {
      return ("FetchError: " + err.why);
    });
    print(valPing);

    // fetch acti
    final resFetchActi = (await fetchAcuatorInfo());
    final valFetchActi = resFetchActi.getOrHandle((err) {
      print("FetchError: " + err.why);
      return ActuatorInfo();
    });

    print(valFetchActi);

    final resFetchEmi = (await fetchElectricmotorInfo());
    final valFetchEmi = resFetchEmi.getOrHandle((err) {
      print("FetchError: " + err.why);
      return ElectricmotorInfo();
    });

    print(valFetchEmi);

    final resFetchEndoi = (await fetchEndotermicmotorInfo());
    final valFetchEndoi = resFetchEndoi.getOrHandle((err) {
      print("FetchError: " + err.why);
      return EndotermicmotorInfo();
    });

    print(valFetchEndoi);

    final resFetchGi = (await fetchGeneralInfo());
    final valFetchGi = resFetchGi.getOrHandle((err) {
      print("FetchError: " + err.why);
      return GeneralInfo.zero();
    });

    print(valFetchGi);

    final resFetchHpbi = (await fetchHighpowerbatteryInfo());
    final valFetchHpbi = resFetchHpbi.getOrHandle((err) {
      print("FetchError: " + err.why);
      return HighpowerbatteryInfo.zero();
    });

    print(valFetchHpbi);

    final resFetchVtgi = (await fetchVTGInfo());
    final valFetchVtgi = resFetchVtgi.getOrHandle((err) {
      print("FetchError: " + err.why);
      return VTGInfo(
          isFixed: false, satellitesCount: 0, SOG: 0, lat: 0, lng: 0);
    });

    print(valFetchVtgi);
  }

  Future<Either<InitError, String>> ping() async {
    String loginData = "";

    try {
      final res = await post(
          Uri.parse("$PROTOCOL://" + DEFAULT_SERVER_NAME + ":$DEFAULT_PORT" "/ping"),
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

  Future<Either<InitError, String>> initServer() async {
    return Either.right("Ok");
  }

  Future<Either<FetchError, ActuatorInfo>> fetchAcuatorInfo() async {
    String loginData = "";

    try {
      final res = await post(
          Uri.parse("$PROTOCOL://" + DEFAULT_SERVER_NAME + ":$DEFAULT_PORT" "/fetch_acti"),
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
        if (res == null)
          return Either.left(
              FetchError(why: "Cannot parse response: " + stringResult));
        return Either.right(res!);
      }
    } on Exception catch (err) {
      return Either.left(FetchError(why: err.toString()));
    }
  }

  // fetch boat information from server
  Future<Either<FetchError, List<BoatInfo>>> fetchBoats() async {
    String loginData = "";

    try {
      final res = await post(
          Uri.parse("$PROTOCOL://" + DEFAULT_SERVER_NAME + ":$DEFAULT_PORT" "/boats"),
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
        print(stringResult);
        List<BoatInfo> ret = [];
        if (res == null)
          return Either.left(
              FetchError(why: "Cannot parse response: " + stringResult));
        return Either.right(ret);
      }
    } on Exception catch (err) {
      return Either.left(FetchError(why: err.toString()));
    }
  }

  Future<Either<FetchError, ElectricmotorInfo>> fetchElectricmotorInfo() async {
    String loginData = "";

    try {
      final res = await post(
          Uri.parse("$PROTOCOL://" + DEFAULT_SERVER_NAME + ":$DEFAULT_PORT" "/fetch_emi"),
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

        ElectricmotorInfo? res = ElectricmotorInfo.fromJSONDynamic(jsonValues);
        if (res == null)
          return Either.left(
              FetchError(why: "Cannot parse response: " + stringResult));
        return Either.right(res!);
      }
    } on Exception catch (err) {
      return Either.left(FetchError(why: err.toString()));
    }
  }

  Future<Either<FetchError, EndotermicmotorInfo>>
      fetchEndotermicmotorInfo() async {
    String loginData = "";

    try {
      final res = await post(
          Uri.parse("$PROTOCOL://" + DEFAULT_SERVER_NAME + ":$DEFAULT_PORT" "/fetch_endoi"),
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

        EndotermicmotorInfo? res =
            EndotermicmotorInfo.fromJSONDynamic(jsonValues);
        if (res == null)
          return Either.left(
              FetchError(why: "Cannot parse response: " + stringResult));
        return Either.right(res!);
      }
    } on Exception catch (err) {
      return Either.left(FetchError(why: err.toString()));
    }
  }

  Future<Either<FetchError, GeneralInfo>> fetchGeneralInfo() async {
    String loginData = "";

    try {
      final res = await post(
          Uri.parse("$PROTOCOL://" + DEFAULT_SERVER_NAME + ":$DEFAULT_PORT" "/fetch_gi"),
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

        GeneralInfo? res = GeneralInfo.fromJSONDynamic(jsonValues);
        if (res == null)
          return Either.left(
              FetchError(why: "Cannot parse response: " + stringResult));
        return Either.right(res!);
      }
    } on Exception catch (err) {
      return Either.left(FetchError(why: err.toString()));
    }
  }

  Future<Either<FetchError, HighpowerbatteryInfo>>
      fetchHighpowerbatteryInfo() async {
    String loginData = "";

    try {
      final res = await post(
          Uri.parse("$PROTOCOL://" + DEFAULT_SERVER_NAME + ":$DEFAULT_PORT" "/fetch_hpbi"),
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

        HighpowerbatteryInfo? res =
            HighpowerbatteryInfo.fromJSONDynamic(jsonValues);
        if (res == null)
          return Either.left(
              FetchError(why: "Cannot parse response: " + stringResult));
        return Either.right(res!);
      }
    } on Exception catch (err) {
      return Either.left(FetchError(why: err.toString()));
    }
  }

  Future<Either<FetchError, VTGInfo>> fetchVTGInfo() async {
    String loginData = "";

    try {
      final res = await post(
          Uri.parse("$PROTOCOL://" + DEFAULT_SERVER_NAME + ":$DEFAULT_PORT" "/fetch_nmea2000/vtgi"),
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

        VTGInfo? res = VTGInfo.fromJSONDynamic(jsonValues);
        if (res == null)
          return Either.left(
              FetchError(why: "Cannot parse response: " + stringResult));
        return Either.right(res!);
      }
    } on Exception catch (err) {
      return Either.left(FetchError(why: err.toString()));
    }
  }

  void setFetchProcess(
      {required Duration interval, required void Function(Timer) callback}) {
    fetch = Timer.periodic(interval, callback);
  }

  void stopFetchProcess() {
    fetch.cancel();
  }
}
