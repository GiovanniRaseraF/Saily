import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:dart_either/dart_either.dart';
import 'package:flutter/material.dart';
import 'package:saily/datatypes/actuator_info.dart';
import 'package:saily/datatypes/boat_info.dart';
import 'package:saily/datatypes/electricmotor_info.dart';
import 'package:saily/datatypes/endotermicmotor_info.dart';
import 'package:saily/datatypes/general_info.dart';
import 'package:saily/datatypes/highpowerbattery_info.dart';
import 'package:saily/datatypes/nmea2000_info.dart';
import 'package:saily/datatypes/user_info.dart';
import 'package:saily/server/server.dart';
import 'package:saily/settings/settings_controller.dart';
import 'package:http/http.dart';
import 'package:latlong2/latlong.dart';
import 'package:saily/tracks/route_reproducer.dart';
import 'package:saily/tracks/gpx_trips.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _UserCredAndData{
  _UserCredAndData({required this.username, required this.password, required this.boats});
  String username = "";
  String password = "";
  List<BoatInfo> boats = [];
}

class MockServerStore {
  MockServerStore({required this.preferences}){}
  SharedPreferences preferences;
  RouteReproducer route1 = RouteReproducer();
  Future<void> loadRoats() async {
    route1.load_parse(veniceTrip);
  }

  List<_UserCredAndData> users = [
    _UserCredAndData(username: "admin@admin", password: "admin", boats: [
      BoatInfo(boat_name: "Roberta", boat_id: "0x0001"),
      BoatInfo(boat_name: "Franca", boat_id: "0x0002"),
    ])
  ];

  bool isBoatInUser(String username, String password, String boat_id){
    final user = getUserInStore(username, password);
    for(final b in user.boats){
      if(b.boat_id == boat_id) return true;
    }
    return false;
  }

  Future<Either<FetchError, VTGInfo>> getVTGInfo(String username, String password, String boat_id) async {
    if(isBoatInUser(username, password, boat_id)){
      final val = route1.getNext();
      final lat = val.latitude;
      final lng = val.longitude;
      var ret = VTGInfo(isFixed: true, satellitesCount: 10, SOG: Random().nextDouble() * 30 + 10, lat: lat, lng: lng);
      return Either.right(ret);
    }else{
      return Either.left(FetchError(why: "no boat"));
    }
  }
  
  Future<Either<FetchError, HighpowerbatteryInfo>> getHpbi(String username, String password, String boat_id) async {
    if(isBoatInUser(username, password, boat_id)){
      var ret = HighpowerbatteryInfo(
        totalVoltage: 100 + Random().nextDouble() * 20, 
        totalCurrent: 100 + Random().nextDouble() * 20, 
        batteryTemperature: 30 + Random().nextDouble() * 20, 
        bmsTemperature: 30 + Random().nextDouble() * 20, 
        SOC: 50 + Random().nextDouble() * 40, 
        power: 40 + Random().nextDouble() * 4, 
        tte: 100, 
        auxBatteryVoltage: 12.1);
      return Either.right(ret);
    }else{
      return Either.left(FetchError(why: "no boat"));
    }
  }

  Future<Either<FetchError, GeneralInfo>> getGi(String username, String password, String boat_id) async {
    if(isBoatInUser(username, password, boat_id)){
      var ret = GeneralInfo(isHybrid: true, isDualMotor: false, versionProtocol: 1, versionFWControlUnit: 1, versionFWDrive: 1, dieselMotorModel: DieselMotorModel.HyundaiS270, electricMotorModel: ElectricMotorModel.THOR6000);
      return Either.right(ret);
    }else{
      return Either.left(FetchError(why: "no boat"));
    }
  }

  Future<Either<FetchError, ElectricmotorInfo>> getEmi(String username, String password, String boat_id) async {
    if(isBoatInUser(username, password, boat_id)){
      var ret = ElectricmotorInfo();
      ret.motorRPM = 2000 + Random().nextDouble() * 1000;
      ret.busVoltage = 20 + Random().nextDouble() * 10;
      ret.inverterTemperature = 20 + Random().nextDouble() * 10;
      ret.motorTemperature = 20 + Random().nextDouble() * 10;
      return Either.right(ret);
    }else{
      return Either.left(FetchError(why: "no boat"));
    }
  }


  bool isUserInStore(String username, String password){
    for(final u in users){
      if(u.username == username && u.password == password) return true;
    }
    return false;
  }

  _UserCredAndData getUserInStore(String username, String password){
    for(final u in users){
      if(u.username == username && u.password == password) return u;
    }
    return _UserCredAndData(username: "", password: "", boats: []);
  }

  List<BoatInfo> getBoats(String username, String password){
    if(isUserInStore(username, password)){
      final u = getUserInStore(username, password);
      return u.boats;
    }else{
      return [];
    }
  }


}

class MockServer extends Server {
  MockServer({required this.settingsController, required this.store}) {
    setFetchProcess(interval: const Duration(milliseconds: 500), callback: fetchProcess);
  }

  // controller
  SettingsController settingsController;
  // data store
  MockServerStore store;

  @override
  void resetCredentials(){
  }

  Future<Either<InitError, String>> ping() async {
    final stringResult = DateTime.now().toIso8601String();

    return Either.right(stringResult);
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

    return Either.right(ActuatorInfo());
  }

  // fetch boat information from server
  @override
  Future<Either<FetchError, List<BoatInfo>>> fetchBoats() async {
    return Either.right([]);
  }

  @override
  Future<Either<FetchError, ElectricmotorInfo>> fetchElectricmotorInfo() async {
    String USERNAME = settingsController.username;
    String PASSWORD = settingsController.password;
    BoatInfo currentBoat = settingsController.getCurretBoat();
    return store.getEmi(USERNAME, PASSWORD, currentBoat.boat_id);
  }

  @override
  Future<Either<FetchError, EndotermicmotorInfo>> fetchEndotermicmotorInfo() async {
    return Either.right(EndotermicmotorInfo());
  }

  @override
  Future<Either<FetchError, GeneralInfo>> fetchGeneralInfo() async {
    String USERNAME = settingsController.username;
    String PASSWORD = settingsController.password;
    BoatInfo currentBoat = settingsController.getCurretBoat();
    return store.getGi(USERNAME, PASSWORD, currentBoat.boat_id);
  }

  @override
  Future<Either<FetchError, HighpowerbatteryInfo>> fetchHighpowerbatteryInfo() async {
    String USERNAME = settingsController.username;
    String PASSWORD = settingsController.password;
    BoatInfo currentBoat = settingsController.getCurretBoat();
    return store.getHpbi(USERNAME, PASSWORD, currentBoat.boat_id);
  }

  @override
  Future<Either<FetchError, VTGInfo>> fetchVTGInfo() async {
    String USERNAME = settingsController.username;
    String PASSWORD = settingsController.password;
    BoatInfo currentBoat = settingsController.getCurretBoat();
    return store.getVTGInfo(USERNAME, PASSWORD, currentBoat.boat_id);
  }

  // returns true if the creadentials are good
  Future<bool> canUserLogin(String username, String password) async {
    return store.isUserInStore(username, password);
  }

  // returns the the list of boats
  @override
  Future<List<BoatInfo>> boatsList(String username, String password) async {
    return store.getBoats(username, password);
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