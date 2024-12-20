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
import 'package:latlong2/latlong.dart';

class HuracanServer extends Server {
  HuracanServer({required this.settingsController}) {
    setFetchProcess(interval: const Duration(seconds: 5), callback: fetchProcess);
  }

  // controller
  SettingsController settingsController;

  // remote
  final DEFAULT_SERVER_NAME = "huracanpower.com";
  final DEFAULT_PORT = 443;
  final PROTOCOL = "https";

  @override
  void resetCredentials(){
  }

  Future<Either<InitError, String>> ping() async {
    String USERNAME = settingsController.username;
    String PASSWORD = settingsController.password;

    String loginData = "username=$USERNAME&password=$PASSWORD";

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
    String USERNAME = settingsController.username;
    String PASSWORD = settingsController.password;
    BoatInfo currentBoat = settingsController.getCurretBoat();
    String loginData = "boat_id=${currentBoat.boat_id}&username=$USERNAME&password=$PASSWORD";

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
          return Either.left(FetchError(why: "Cannot parse response: $stringResult"));
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
    String USERNAME = settingsController.username;
    String PASSWORD = settingsController.password;
    BoatInfo currentBoat = settingsController.getCurretBoat();
    String loginData = "boat_id=${currentBoat.boat_id}&username=$USERNAME&password=$PASSWORD";

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
    String USERNAME = settingsController.username;
    String PASSWORD = settingsController.password;
    BoatInfo currentBoat = settingsController.getCurretBoat();
    String loginData = "boat_id=${currentBoat.boat_id}&username=$USERNAME&password=$PASSWORD";

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
    String USERNAME = settingsController.username;
    String PASSWORD = settingsController.password;
    BoatInfo currentBoat = settingsController.getCurretBoat();
    String loginData = "boat_id=${currentBoat.boat_id}&username=$USERNAME&password=$PASSWORD";

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
    String USERNAME = settingsController.username;
    String PASSWORD = settingsController.password;
    BoatInfo currentBoat = settingsController.getCurretBoat();
    String loginData = "boat_id=${currentBoat.boat_id}&username=$USERNAME&password=$PASSWORD";

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
    String USERNAME = settingsController.username;
    String PASSWORD = settingsController.password;
    BoatInfo currentBoat = settingsController.getCurretBoat();
    String loginData = "boat_id=${currentBoat.boat_id}&username=$USERNAME&password=$PASSWORD";

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
    String USERNAME = settingsController.username;
    String PASSWORD = settingsController.password;
    BoatInfo currentBoat = settingsController.getCurretBoat();
    String loginData = "boat_id=${currentBoat.boat_id}&username=$USERNAME&password=$PASSWORD";

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

  // returns true if the creadentials are good
  Future<bool> canUserLogin(String username, String password) async {
    String loginData = "username=$username&password=$password";
    try {
      final res = await post(
          Uri.parse("$PROTOCOL://$DEFAULT_SERVER_NAME:$DEFAULT_PORT/login"),
          body: loginData,
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
          });

      final response = res.body;

      // checking response
      if (response.isEmpty) {
        print("Login is empty");
        return false;
      } else {
        print(response);
        final jsonResponse = jsonDecode(response.toString());
        if(jsonResponse["error"] != null){
          return false;
        }else {
          return jsonResponse["canuselogin"] as bool;
        }
      }
    } on Exception catch (err) {
      print(err);
      return false;
    }
  }

  // returns the the list of boats
  @override
  Future<List<BoatInfo>> boatsList(String username, String password) async {
    String loginData = "username=$username&password=$password";
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
        print("response for boat is empty");
        return [];
      } else {
        //print(response);
        final jsonResponse = jsonDecode(response.toString());
        if(jsonResponse["error"] != null){
          return [];
        }else {
          List<dynamic> boatsDynamic = jsonResponse["boats"];
          List<BoatInfo> boats = [];

          for (dynamic dyn in boatsDynamic) {
            final boat = BoatInfo.fromJSONDynamic(dyn);
            if (boat != null) {
              boats.add(boat);
            }
          }

          return boats;
        }
      }
    } on Exception catch (err) {
      print(err);
      return [];
    }
  }

  @override 
  Future<bool> addNewBoat(BoatInfo newBoat) async {
    final ret = await ping();
      if (ret.isRight){
        return true;
      }
      return false;
  }

  @override 
  Future<bool> deleteBoat(BoatInfo toDelete) async {
    final ret = await ping();
    if (ret.isRight){
      return true;
    }
    return false;
  }

  @override   
  Future<void> fetchAll() async {
    print("Fetching data....");
    print(".");
    print("...");

    BoatInfo currentBoat = settingsController.getCurretBoat();
    // no user selected
    if(! settingsController.isUserLogged()) return;
    // no boat selected
    if(currentBoat.boat_id == "") return;

    // // fetch acti
    final resPing = (ping());
    resPing.then((v){
      final val = v.getOrHandle((err) {  
        return "error";
      });

      if(val == "error"){
        settingsController.sendConnectionToServerStatus(ConnectionToServerStatus.FETCH_ERROR);
      }else{
        settingsController.sendConnectionToServerStatus(ConnectionToServerStatus.ONLINE);
      }
    });

    // // fetch acti
    final resFetchActi = (fetchAcuatorInfo());
    resFetchActi.then((v){
      final valFetchActi = v.getOrHandle((err) {
        debugPrint("FetchError: ${err.why}");
        return ActuatorInfo();
      });
      // TODO: acutator info on settingsController
      debugPrint(valFetchActi.toString());
    });

    final resFetchEmi = (fetchElectricmotorInfo());
    resFetchEmi.then((v){
      final valFetchEmi = v.getOrHandle((err) {
        debugPrint("FetchError: ${err.why}");
        return ElectricmotorInfo();
      });
      settingsController.electricmotorInfoStream.sink.add(valFetchEmi); 
      debugPrint(valFetchEmi.toString());
    });

    final resFetchEndoi = (fetchEndotermicmotorInfo());
    resFetchEndoi.then((v){
      final valFetchEndoi = v.getOrHandle((err) {
        debugPrint("FetchError: ${err.why}");
        return EndotermicmotorInfo();
      });
      settingsController.endotermicmotorInfoStream.sink.add(valFetchEndoi); 
      debugPrint(valFetchEndoi.toString());
    });

    final resFetchGi = (fetchGeneralInfo());
    resFetchGi.then((v){
      final valFetchGi = v.getOrHandle((err) {
        debugPrint("FetchError: ${err.why}");
        return GeneralInfo.zero();
      });

      settingsController.generalInfoStream.sink.add(valFetchGi); 
      debugPrint(valFetchGi.toString());
    });

    // battery
    final resFetchHpbi = (fetchHighpowerbatteryInfo());
    resFetchHpbi.then((v){
      final valFetchHpbi = v.getOrHandle((err) {
        debugPrint("FetchError: ${err.why}");
        return HighpowerbatteryInfo.zero();
      });

      settingsController.highpowerbatteryInfoStream.sink.add(valFetchHpbi);

      debugPrint(valFetchHpbi.toString());
    });

    // position
    final resFetchVtgi = (fetchVTGInfo());
    resFetchVtgi.then((v){
      var valFetchVtgi = v.getOrHandle((err) {
        debugPrint("FetchError: ${err.why}");
        return VTGInfo(
            isFixed: false, satellitesCount: 0, SOG: 0, lat: 0, lng: 0);
      });

      LatLng send = LatLng(valFetchVtgi.lat, valFetchVtgi.lng);
      settingsController.currentBoatPositionStream.sink.add(send);
      settingsController.sendNVTGInfo(valFetchVtgi);

      debugPrint(valFetchVtgi.toString());
    });
  }

  //////////////////////////
  /// BackGround Process ///
  //////////////////////////
   
  Future<void> fetchProcess(Timer t) async {
    await fetchAll(); 
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
