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
    setFetchProcess(interval: const Duration(seconds: 5), callback: fetchProcess);
  }
  SettingsController settingsController;

  String USERNAME = "g.rasera@huracanmarine.com";
  String PASSWORD = "MoroRacing2024";
  // final DEFAULT_SERVER_NAME = "huracanpower.com";
  // final DEFAULT_PORT = 443;
  // final PROTOCOL = "https";
  String DEFAULT_SERVER_NAME = "localhost";
  int DEFAULT_PORT = 8567;
  String PROTOCOL = "http";

  // current boat
  BoatInfo currentBoat = BoatInfo(name: "default", id: "0x0");

  Future<Either<InitError, String>> ping() async {
    String loginData = "boat_id=${currentBoat.id}&username=$USERNAME&password=$PASSWORD";

    try {
      final res = await post(
          Uri.parse("$PROTOCOL://$DEFAULT_SERVER_NAME:$DEFAULT_PORT/ping"),
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

  @override
  Future<Either<InitError, String>> initServer() async {
    return const Either.right("Ok");
  }

  @override
  Future<Either<FetchError, ActuatorInfo>> fetchAcuatorInfo() async {
    String loginData = "boat_id=${currentBoat.id}&username=$USERNAME&password=$PASSWORD";

    try {
      final res = await post(
          Uri.parse("$PROTOCOL://$DEFAULT_SERVER_NAME:$DEFAULT_PORT/fetch_acti"),
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
        if (res == null) {
          return Either.left(
              FetchError(why: "Cannot parse response: $stringResult"));
        }
        return Either.right(res!);
      }
    } on Exception catch (err) {
      return Either.left(FetchError(why: err.toString()));
    }
  }

  // fetch boat information from server
  @override
  Future<Either<FetchError, List<BoatInfo>>> fetchBoats() async {
    String loginData = "boat_id=${currentBoat.id}&username=$USERNAME&password=$PASSWORD";

    try {
      final res = await post(
          Uri.parse("$PROTOCOL://$DEFAULT_SERVER_NAME:$DEFAULT_PORT/boats"),
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
        debugPrint(stringResult);
        List<BoatInfo> ret = [];
        if (res == null) {
          return Either.left(
              FetchError(why: "Cannot parse response: $stringResult"));
        }
        return Either.right(ret);
      }
    } on Exception catch (err) {
      return Either.left(FetchError(why: err.toString()));
    }
  }

  @override
  Future<Either<FetchError, ElectricmotorInfo>> fetchElectricmotorInfo() async {
    String loginData = "boat_id=${currentBoat.id}&username=$USERNAME&password=$PASSWORD";

    try {
      final res = await post(
          Uri.parse("$PROTOCOL://$DEFAULT_SERVER_NAME:$DEFAULT_PORT/fetch_emi"),
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
        if (res == null) {
          return Either.left(
              FetchError(why: "Cannot parse response: $stringResult"));
        }
        return Either.right(res!);
      }
    } on Exception catch (err) {
      return Either.left(FetchError(why: err.toString()));
    }
  }

  @override
  Future<Either<FetchError, EndotermicmotorInfo>>
      fetchEndotermicmotorInfo() async {
    String loginData = "boat_id=${currentBoat.id}&username=$USERNAME&password=$PASSWORD";

    try {
      final res = await post(
          Uri.parse("$PROTOCOL://$DEFAULT_SERVER_NAME:$DEFAULT_PORT/fetch_endoi"),
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
        if (res == null) {
          return Either.left(
              FetchError(why: "Cannot parse response: $stringResult"));
        }
        return Either.right(res!);
      }
    } on Exception catch (err) {
      return Either.left(FetchError(why: err.toString()));
    }
  }

  @override
  Future<Either<FetchError, GeneralInfo>> fetchGeneralInfo() async {
    String loginData = "boat_id=${currentBoat.id}&username=$USERNAME&password=$PASSWORD";

    try {
      final res = await post(
          Uri.parse("$PROTOCOL://$DEFAULT_SERVER_NAME:$DEFAULT_PORT/fetch_gi"),
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
        if (res == null) {
          return Either.left(
              FetchError(why: "Cannot parse response: $stringResult"));
        }
        return Either.right(res!);
      }
    } on Exception catch (err) {
      return Either.left(FetchError(why: err.toString()));
    }
  }

  @override
  Future<Either<FetchError, HighpowerbatteryInfo>>
      fetchHighpowerbatteryInfo() async {
    String loginData = "boat_id=${currentBoat.id}&username=$USERNAME&password=$PASSWORD";

    try {
      final res = await post(
          Uri.parse("$PROTOCOL://$DEFAULT_SERVER_NAME:$DEFAULT_PORT/fetch_hpbi"),
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
        if (res == null) {
          return Either.left(
              FetchError(why: "Cannot parse response: $stringResult"));
        }
        return Either.right(res!);
      }
    } on Exception catch (err) {
      return Either.left(FetchError(why: err.toString()));
    }
  }

  @override
  Future<Either<FetchError, VTGInfo>> fetchVTGInfo() async {
    String loginData = "boat_id=${currentBoat.id}&username=$USERNAME&password=$PASSWORD";

    try {
      final res = await post(
          Uri.parse("$PROTOCOL://$DEFAULT_SERVER_NAME:$DEFAULT_PORT/fetch_nmea2000/vtgi"),
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
        if (res == null) {
          return Either.left(
              FetchError(why: "Cannot parse response: $stringResult"));
        }
        return Either.right(res!);
      }
    } on Exception catch (err) {
      return Either.left(FetchError(why: err.toString()));
    }
  }

  //////////////////////////
  /// BackGround Process ///
  //////////////////////////
   
  Future<void> fetchProcess(Timer t) async {
    debugPrint("-");
    debugPrint("--");
    debugPrint("---");
    debugPrint("-----");
    debugPrint("------");
    debugPrint("\n\n\nRunning fetch..");

    // init with ping
    final resPing = (await ping());
    final valPing = resPing.getOrHandle((err) {
      return ("FetchError: ${err.why}");
    });
    debugPrint(valPing);

    // fetch acti
    final resFetchActi = (await fetchAcuatorInfo());
    final valFetchActi = resFetchActi.getOrHandle((err) {
      debugPrint("FetchError: ${err.why}");
      return ActuatorInfo();
    });

    debugPrint(valFetchActi.toString());

    final resFetchEmi = (await fetchElectricmotorInfo());
    final valFetchEmi = resFetchEmi.getOrHandle((err) {
      debugPrint("FetchError: ${err.why}");
      return ElectricmotorInfo();
    });

    debugPrint(valFetchEmi.toString());

    final resFetchEndoi = (await fetchEndotermicmotorInfo());
    final valFetchEndoi = resFetchEndoi.getOrHandle((err) {
      debugPrint("FetchError: ${err.why}");
      return EndotermicmotorInfo();
    });

    debugPrint(valFetchEndoi.toString());

    final resFetchGi = (await fetchGeneralInfo());
    final valFetchGi = resFetchGi.getOrHandle((err) {
      debugPrint("FetchError: ${err.why}");
      return GeneralInfo.zero();
    });

    debugPrint(valFetchGi.toString());

    final resFetchHpbi = (await fetchHighpowerbatteryInfo());
    final valFetchHpbi = resFetchHpbi.getOrHandle((err) {
      debugPrint("FetchError: ${err.why}");
      return HighpowerbatteryInfo.zero();
    });

    debugPrint(valFetchHpbi.toString());

    final resFetchVtgi = (await fetchVTGInfo());
    final valFetchVtgi = resFetchVtgi.getOrHandle((err) {
      debugPrint("FetchError: ${err.why}");
      return VTGInfo(
          isFixed: false, satellitesCount: 0, SOG: 0, lat: 0, lng: 0);
    });

    debugPrint(valFetchVtgi.toString());
  }

  @override
  void setFetchProcess(
      {required Duration interval, required void Function(Timer) callback}) {
    fetch = Timer.periodic(interval, callback);
  }

  @override
  void stopFetchProcess() {
    fetch.cancel();
  }
}
