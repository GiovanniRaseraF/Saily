/*
author: Giovanni Rasera
*/

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:saily/datatypes/boat_info.dart';
import 'package:saily/datatypes/electricmotor_info.dart';
import 'package:saily/datatypes/endotermicmotor_info.dart';
import 'package:saily/datatypes/general_info.dart';
import 'package:saily/datatypes/nmea2000_info.dart';
import 'package:saily/datatypes/highpowerbattery_info.dart';
import 'package:saily/datatypes/route_info.dart';
import 'package:saily/datatypes/user_info.dart';
import 'package:saily/datatypes/vehicle_info.dart';
import 'package:saily/server/server.dart';
import 'package:saily/settings/settings_service.dart';
import 'package:latlong2/latlong.dart';
import 'package:camera/camera.dart';

class SettingsController extends ChangeNotifier {
  SettingsController({required this.settingsService}) {
    // create a broadcast stream
    currentBoatPositionStream = StreamController<LatLng>.broadcast();

    // map
    followMapRotationStream = StreamController<bool>.broadcast();
    expandTileStream = StreamController<bool>.broadcast();
    currentMapFakeOffsetStream = StreamController<double>.broadcast();

    // gps recording
    currentRouteToFollow = StreamController<RouteInfo>.broadcast();
    currentRouteBuilding = StreamController<RouteInfo>.broadcast();
    currentBoat = settingsService.loadCurrentBoat();

    // Units info
    sogUnitStream = StreamController<String>.broadcast();
    motorTempUnitStream = StreamController<String>.broadcast();

    // load username
    username = settingsService.loadUsername();
    password = settingsService.loadPassword();

    // Info Streams
    nVTGInfoStream = StreamController<VTGInfo>.broadcast();
    generalInfoStream = StreamController<GeneralInfo>.broadcast();
    electricmotorInfoStream = StreamController<ElectricmotorInfo>.broadcast();
    highpowerbatteryInfoStream =
        StreamController<HighpowerbatteryInfo>.broadcast();
    endotermicmotorInfoStream =
        StreamController<EndotermicmotorInfo>.broadcast();
    vehicleInfoStream = StreamController<VehicleInfo>.broadcast();
    currentNVTGInfo =
        VTGInfo(isFixed: true, satellitesCount: 0, SOG: 0, lat: 0, lng: 0);
    currentGeneralInfo = GeneralInfo(
        dieselMotorModel: DieselMotorModel.None,
        electricMotorModel: ElectricMotorModel.None,
        isDualMotor: false,
        isHybrid: false,
        versionFWControlUnit: 0,
        versionFWDrive: 0,
        versionProtocol: 0);
    currentElectricMotorInfo = ElectricmotorInfo();
    currentHighpowerbatteryInfo = HighpowerbatteryInfo(
        SOC: 0,
        auxBatteryVoltage: 0,
        batteryTemperature: 0,
        bmsTemperature: 0,
        power: 0,
        totalCurrent: 0,
        totalVoltage: 0,
        tte: 0);
    currentEndotermicmotorInfo = EndotermicmotorInfo();
    currentVehicleInfo = VehicleInfo();

    // Connection Status
    connectionToServerStatus = ConnectionToServerStatus.ONLINE;
    connectionToServerStatusStream =
        StreamController<ConnectionToServerStatus>.broadcast();
  }

  String username = "";
  String password = "";
  bool logged = false;

  // camera
  late CameraDescription camera;

  // service
  SettingsService settingsService;

  ///
  /// Boat info
  ///
  late String selectedBoatdId;
  late StreamController<LatLng> currentBoatPositionStream;

  // map
  late StreamController<bool> followMapRotationStream;
  late StreamController<bool> expandTileStream;
  late StreamController<double> currentMapFakeOffsetStream;

  // gps recording
  List<LatLng> listOfRecordedPositions = [];
  List<HighpowerbatteryInfo> listOfRecordedHpbi = [];
  List<ElectricmotorInfo> listOfRecordedEmi = [];
  List<VTGInfo> listOfRecordedVtgi = [];
  List<String> listOfIds = [];
  late StreamController<RouteInfo> currentRouteToFollow;
  late StreamController<RouteInfo> currentRouteBuilding;
  late BoatInfo currentBoat;

  // Units info
  late StreamController<String> sogUnitStream;
  late StreamController<String> motorTempUnitStream;

  // Info Stream
  late VTGInfo currentNVTGInfo;
  late StreamController<VTGInfo> nVTGInfoStream;

  late GeneralInfo currentGeneralInfo;
  late StreamController<GeneralInfo> generalInfoStream;

  late ElectricmotorInfo currentElectricMotorInfo;
  late StreamController<ElectricmotorInfo> electricmotorInfoStream;

  late HighpowerbatteryInfo currentHighpowerbatteryInfo;
  late StreamController<HighpowerbatteryInfo> highpowerbatteryInfoStream;

  late EndotermicmotorInfo currentEndotermicmotorInfo;
  late StreamController<EndotermicmotorInfo> endotermicmotorInfoStream;

  late VehicleInfo currentVehicleInfo;
  late StreamController<VehicleInfo> vehicleInfoStream;

  // Connection Status
  late ConnectionToServerStatus connectionToServerStatus;
  late StreamController<ConnectionToServerStatus>
      connectionToServerStatusStream;

  // stream getters
  Stream<VTGInfo> getNVTGStream() {
    return nVTGInfoStream.stream;
  }

  Stream<GeneralInfo> getGeneralInfoStream() {
    return generalInfoStream.stream;
  }

  Stream<ElectricmotorInfo> getElectricMotorInfoStream() {
    return electricmotorInfoStream.stream;
  }

  Stream<HighpowerbatteryInfo> getHighPowerBatteryInfoStream() {
    return highpowerbatteryInfoStream.stream;
  }

  Stream<EndotermicmotorInfo> getEndotermicMotorInfoStream() {
    return endotermicmotorInfoStream.stream;
  }

  Stream<VehicleInfo> getVehicleInfoStream() {
    return vehicleInfoStream.stream;
  }

  Stream<ConnectionToServerStatus> getConnectionToServerStatusStream() {
    return connectionToServerStatusStream.stream;
  }

  ///
  /// Send values to streams
  ///
  ///
  void sendNVTGInfo(VTGInfo? newN) {
    if (newN == null) return;

    currentNVTGInfo = newN;
    nVTGInfoStream.sink.add(newN);
  }

  void sendGeneralInfo(GeneralInfo? newG) {
    if (newG == null) return;

    currentGeneralInfo = newG;
    generalInfoStream.sink.add(newG);
  }

  void sendElectricMotorInfo(ElectricmotorInfo? newE) {
    if (newE == null) return;

    currentElectricMotorInfo = newE;
    electricmotorInfoStream.sink.add(newE);
  }

  void sendHighPowerBatteryInfo(HighpowerbatteryInfo? newH) {
    if (newH == null) return;

    currentHighpowerbatteryInfo = newH;
    highpowerbatteryInfoStream.sink.add(newH);
  }

  void sendEndotermicMotorInfo(EndotermicmotorInfo? newE) {
    if (newE == null) return;

    currentEndotermicmotorInfo = newE;
    endotermicmotorInfoStream.sink.add(newE);
  }

  void sendVehicleInfo(VehicleInfo? newV) {
    if (newV == null) return;

    currentVehicleInfo = newV;
    vehicleInfoStream.sink.add(newV);
  }

  void sendConnectionToServerStatus(ConnectionToServerStatus? newV) {
    if (newV == null) return;

    connectionToServerStatus = newV;
    connectionToServerStatusStream.sink.add(newV);
  }

  void setUsername(String us) {
    settingsService.setUsername(us);
  }

  void setPassword(String us) {
    settingsService.setPassword(us);
  }

  void setCurrentBoat(BoatInfo boat) {
    currentBoat = boat;
    settingsService.setCurrentBoat(boat);
  }

  void login(String username, String password) {
    settingsService.setUsername(username);
    settingsService.setPassword(password);

    logged = true;
  }

  bool isUserLogged() {
    return logged;
  }

  String getUsername() {
    username = settingsService.loadUsername();
    return username;
  }

  String getPassword() {
    password = settingsService.loadPassword();
    return password;
  }

  BoatInfo getCurretBoat() {
    return currentBoat;
  }

  void logout() {
    username = "";
    password = "";
    currentBoat = BoatInfo(boat_name: "", boat_id: "");

    settingsService.setUsername(username);
    settingsService.setPassword(password);
    settingsService.setCurrentBoat(currentBoat);

    logged = false;
  }

  Stream<String> getSogUnitStream() {
    return sogUnitStream.stream;
  }

  Stream<String> getMotorTempStream() {
    return motorTempUnitStream.stream;
  }

  void sendSogUnit(String? unit) {
    if (unit == null) return;

    settingsService.setString("sog-unit", unit);
    final send = settingsService.getString("sog-unit");

    sogUnitStream.add(send!);
  }

  void setMotorTempUnit(String? unit) {
    if (unit == null) return;
    settingsService.setString("motor-temp-unit", unit);
    final send = settingsService.getString("motor-temp-unit");
    motorTempUnitStream.add(send!);
  }

  String getCurrentSogUnit() {
    final send = settingsService.getString("sog-unit");

    if (send == null) {
      settingsService.setString("sog-unit", "km/h");
      return "km/h";
    }

    return send;
  }

  String getMotorTempUnit() {
    final send = settingsService.getString("motor-temp-unit");
    if (send == null) {
      settingsService.setString("motor-temp-unit", "C");
      return "C";
    }
    return send;
  }

  // camera load
  CameraDescription getCamera() {
    return camera;
  }

  Future<void> loadDependeces() async {
    try {
      var cam = await availableCameras();
      camera = cam.first;
    } on Exception {
      print("No camera available :) ");
    }
  }

  ///
  /// Set the new active route to follow
  ///
  void setActiveRoute(RouteInfo routeToFollow) {
    currentRouteToFollow.sink.add(routeToFollow);
  }

  ///
  /// Clear the new active route to follow
  ///
  void clearActiveRoute() {
    RouteInfo empty = RouteInfo(
        name: "empty",
        positions: [],
        from: DateTime.now().toString(),
        to: DateTime.now().toString(),
        hpibInfo: [],
        emInfo: [],
        vtgInfo: []
        );
    currentRouteToFollow.sink.add(empty);
  }

  Stream<RouteInfo> getActiveRouteStream() {
    return currentRouteToFollow.stream;
  }

  Stream<RouteInfo> getCurrentRouteStream() {
    return currentRouteBuilding.stream;
  }

  void importRoute(RouteInfo r) {
    settingsService.addRouteToUser(username, r);
  }

  ///
  /// Record new postion
  ///
  void addPositionToRecordedPositions(LatLng? newPosition) {
    if (newPosition == null) {
      return;
    }

    listOfRecordedPositions.add(newPosition);
    RouteInfo current = RouteInfo(
        name: "current",
        positions: this.listOfRecordedPositions,
        from: DateTime.now().toString(),
        to: DateTime.now().toString(),
        hpibInfo: [],
        emInfo: [],
        vtgInfo: []);
    currentRouteBuilding.sink.add(current);
  }

  ///
  /// Record new hpbi
  ///
  void addPositionToRecordedHpbi(HighpowerbatteryInfo? newV) {
    if (newV == null) {
      return;
    }

    listOfRecordedHpbi.add(newV);
  }

  ///
  /// Record new emi
  ///
  void addPositionToRecordedEmi(ElectricmotorInfo? newV) {
    if (newV == null) {
      return;
    }

    listOfRecordedEmi.add(newV);
  }

  ///
  /// Record new vtgi
  ///
  void addPositionToRecordedVtgi(VTGInfo? newV) {
    if (newV == null) {
      return;
    }

    listOfRecordedVtgi.add(newV);
  }

  ///
  /// Rest the recorder positions
  ///
  void resetRecorderPositions() {
    listOfRecordedPositions = [];
    listOfRecordedHpbi = [];
    listOfRecordedEmi = [];
    listOfRecordedVtgi = [];

    RouteInfo current = RouteInfo(
        name: "current",
        positions: [],
        from: DateTime.now().toString(),
        to: DateTime.now().toString(),
        hpibInfo: [],
        emInfo: [],
        vtgInfo: []);
    currentRouteBuilding.sink.add(current);
  }

  ///
  /// Save recroder positions
  ///
  void saveRecorderPositions(String name, String from) {
    String to = DateTime.now().toString();

    if (name.trim() == "") {
      name = "GenericRoute";
    }

    RouteInfo newRoute = RouteInfo(
        name: name.trim(),
        positions: listOfRecordedPositions,
        from: from,
        to: to,
        hpibInfo: listOfRecordedHpbi,
        emInfo: listOfRecordedEmi,
        vtgInfo: listOfRecordedVtgi);
    settingsService.addRouteToUser(username, newRoute);
  }

  void deleteRoute(String id) {
    settingsService.deleteRoute(id, username);
  }

  ///
  /// Get route info
  ///
  RouteInfo? getRouteInfo(String id) {
    //settingsService.getRouteInfo(id, username);
  }

  List<RouteInfo> getRoutes() {
    return settingsService.getRoutes(username);
  }

  ///
  /// Send new position to the broadcast stream controller
  ///
  void updateCurrentBoatPosition(LatLng? newPosition) {
    if (newPosition == null) {
      debugPrint("updateCurrentBoatPosition: newPosition is null");
      return;
    }

    // send to stream
    currentBoatPositionStream.sink.add(newPosition);
  }

  ///
  /// Get the stream controller
  ///
  Stream<LatLng> getCurrentBoatPositionStream() {
    return currentBoatPositionStream.stream;
  }

  ///
  /// Send
  ///
  void updateFollowMapRotation(bool? followmr) {
    if (followmr == null) {
      debugPrint("updateFollowMapRotation: folloms is null");
      return;
    } else {
      followMapRotationStream.sink.add(followmr);
    }
  }

  ///
  /// Get
  ///
  Stream<bool> getFollowMapRotationStream() {
    return followMapRotationStream.stream;
  }

  ///
  /// getFollowMapRotationValue
  ///
  Future<bool> getFollowMapRotationValue() async {
    final ret = await settingsService.getBool("follow-map-rotation",
        defaultValue: false)!;

    updateFollowMapRotation(ret);

    return ret;
  }

  ///
  /// Send
  ///
  void updateExpandTile(bool? expanded) {
    if (expanded == null) {
      debugPrint("updateExpandTile: folloms is null");
      return;
    } else {
      debugPrint("updateExpandTile: sending to broadcast $expanded");
      expandTileStream.sink.add(expanded);
      if (expanded) {
        updateCurrentMapFakeOffset(0.03);
      } else {
        updateCurrentMapFakeOffset(0);
      }
    }
  }

  ///
  /// Get
  ///
  Stream<bool> getExpandTileStream() {
    return expandTileStream.stream;
  }

  ///
  /// getExpandTileValue
  ///
  Future<bool> getExpandTileValue() async {
    bool ret = settingsService.getBool("expand-tile", defaultValue: false)!;

    updateExpandTile(ret);

    return ret;
  }

  ///
  /// Set value of expanded tile
  ///
  Future<void> setExpandedTileValue(bool? value) async {
    if (value == null) return;
    settingsService.setBool("expand-tile", value);

    updateExpandTile(value);
  }

  ///
  /// Current Map Fake Offset
  ///
  void updateCurrentMapFakeOffset(double? fakeoffset) {
    if (fakeoffset == null) {
      debugPrint("updateCurrentMapFakeOffset: folloms is null");
      return;
    } else {
      debugPrint(
          "updateCurrentMapFakeOffset: sending to broadcast $fakeoffset");
      currentMapFakeOffsetStream.sink.add(fakeoffset);
    }
  }

  Stream<double> getCurrentMapFakeOffsetStream() {
    return currentMapFakeOffsetStream.stream;
  }

  Future<double> getCurrentMapFakeOffsetValue() async {
    final ret =
        await settingsService.getDouble("map-fake-offset", defaultValue: 0)!;

    updateCurrentMapFakeOffset(ret);

    return ret;
  }

  Future<void> setCurrentMapFakeOffsetValue(double? value) async {
    if (value == null) return;
    settingsService.setDouble("map-fake-offset", value);

    updateCurrentMapFakeOffset(value);
  }
}
