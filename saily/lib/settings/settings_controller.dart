import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:saily/datatypes/battery_info.dart';
import 'package:saily/datatypes/boat_info.dart';
import 'package:saily/datatypes/gps_info.dart';
import 'package:saily/datatypes/route_info.dart';
import 'package:saily/datatypes/user_info.dart';
import 'package:saily/settings/settings_service.dart';
import 'package:latlong2/latlong.dart';
import 'package:camera/camera.dart';

class SettingsController extends ChangeNotifier {
  SettingsController({required this.settingsService}) {
    // create a broadcast stream
    currentBoatPositionStream = StreamController<LatLng>.broadcast();
    currentGpsCounterStream = StreamController<GpsInfo>.broadcast();
    currentBatteryInfoStream = StreamController<BatteryInfo>.broadcast();

    // map
    followMapRotationStream = StreamController<bool>.broadcast();
    expandTileStream = StreamController<bool>.broadcast();
    currentMapFakeOffsetStream = StreamController<double>.broadcast();

    // current off set value

    // gps recording
    currentRouteToFollow = StreamController<RouteInfo>.broadcast();
    currentRouteBuilding = StreamController<RouteInfo>.broadcast();

    // load ids
    listOfIds = settingsService.loadRoutesIds();

    // Units info
    sogUnitStream = StreamController<String>.broadcast();
    motorTempUnitStream = StreamController<String>.broadcast();
  }

  String username = "";
  String password = "";

  // camera
  late CameraDescription camera;

  // service
  SettingsService settingsService;

  ///
  /// Boat info
  ///
  late String selectedBoatdId;
  late StreamController<LatLng> currentBoatPositionStream;
  late StreamController<GpsInfo> currentGpsCounterStream;
  late StreamController<BatteryInfo> currentBatteryInfoStream;

  // map
  late StreamController<bool> followMapRotationStream;
  late StreamController<bool> expandTileStream;
  late StreamController<double> currentMapFakeOffsetStream;

  // gps recording
  List<LatLng> listOfRecordedPositions = [];
  List<String> listOfIds = [];
  late StreamController<RouteInfo> currentRouteToFollow;
  late StreamController<RouteInfo> currentRouteBuilding;

  // Units info
  late StreamController<String> sogUnitStream;
  late StreamController<String>  motorTempUnitStream;

  void addUser(UserInfo newUser){
    settingsService.saveUser(newUser);
  }

  bool canAddUser(UserInfo newUser){
    return settingsService.canAddUser(newUser);
  }

  bool canUserLogin(String usename, String password){
    return settingsService.canUserLogin(usename, password);
  }

  void login(String username, String password){
    if(canUserLogin(username, password)){
      settingsService.loadUser(username, password);
      this.username = username;
      this.password = password;
    }
  }

  void logout(){
    username = "";
    password = "";
  }

  UserInfo? getUser(String username, String password){
    return settingsService.loadUser(username, password);
  }

  Stream<String> getSogUnitStream() {
    return sogUnitStream.stream;
  }

  Stream<String> getMotorTempStream() {
    return motorTempUnitStream.stream;
  }

  void setSogUnit(String? unit){
    if(unit == null) return;
    settingsService.setString("sog-unit", unit);
    final send = settingsService.getString("sog-unit");
    sogUnitStream.add(send!);
  }

  void setMotorTempUnit(String? unit){
    if(unit == null) return;
    settingsService.setString("motor-temp-unit", unit);
    final send = settingsService.getString("motor-temp-unit");
    motorTempUnitStream.add(send!);
  }

  String getSogUnit(){
    final send = settingsService.getString("sog-unit");
    if(send == null){
      settingsService.setString("sog-unit", "km/h");
      return "km/h";
    }
    return send;
  }

  String getMotorTempUnit(){
    final send = settingsService.getString("motor-temp-unit");
    if(send == null){
      settingsService.setString("motor-temp-unit", "C");
      return "C";
    }
    return send;
  }


  // camera load
  CameraDescription getCamera(){
    return camera;
  }

  Future<void> loadDependeces() async {
    var cam = await availableCameras();
    camera = cam.first;
  }

  void addNewBoat(BoatInfo newboat){
    UserInfo? currentUser = settingsService.loadUser(username, password);
    if(currentUser == null) return;
    currentUser!.addBoat(newboat);
    settingsService.saveUser(currentUser!);
  }

  void deleteBoat(String id){
    UserInfo? currentUser = settingsService.loadUser(username, password);
    if(currentUser == null) return;
    List<BoatInfo> newList = [];
    for(final b in currentUser!.boats){
      if(b.id != id){
        newList.add(b);
      }
    }

    currentUser!.boats = newList;
    settingsService.saveUser(currentUser!);
  }

  UserInfo? getLoggedUser(){
    return settingsService.loadUser(username, password);
  }

  ///
  /// Set the new active route to follow
  ///
  void setActiveRoute(RouteInfo routeToFollow){
    currentRouteToFollow.sink.add(routeToFollow);
  }

  ///
  /// Clear the new active route to follow
  ///
  void clearActiveRoute(){
    RouteInfo empty = RouteInfo(name: "empty", positions: [], from: DateTime.now().toString(), to: DateTime.now().toString());
    currentRouteToFollow.sink.add(empty);
  }
  
  Stream<RouteInfo> getActiveRouteStream() {
    return currentRouteToFollow.stream;
  }

  Stream<RouteInfo> getCurrentRouteStream() {
    return currentRouteBuilding.stream;
  }

  void importRoute(RouteInfo r){
    settingsService.saveRouteInfo(r.name, r.positions, r.from, r.to);
    listOfIds.add(r.to);
    settingsService.saveRoutesIds(listOfIds);
  }

  ///
  /// Record new postion
  ///
  void addPositionToRecordedPositions(LatLng? newPosition){
    if (newPosition == null) {
      return;
    }

    listOfRecordedPositions.add(newPosition);
    RouteInfo current = RouteInfo(name: "current", positions: this.listOfRecordedPositions, from: DateTime.now().toString(), to: DateTime.now().toString());
    currentRouteBuilding.sink.add(current);
  }

  ///
  /// Rest the recorder positions
  ///
  void resetRecorderPositions(){
    listOfRecordedPositions = [];
    
    RouteInfo current = RouteInfo(name: "current", positions: this.listOfRecordedPositions, from: DateTime.now().toString(), to: DateTime.now().toString());
    currentRouteBuilding.sink.add(current);
  }

  ///  
  /// Save recroder positions
  /// 
  void saveRecorderPositions(String name, String from){
    String to = DateTime.now().toString();

    if(name.trim() == ""){
      name = "GenericRoute";
    }

    settingsService.saveRouteInfo(name.trim(), listOfRecordedPositions, from, to);
    listOfIds.add(to);
    settingsService.saveRoutesIds(listOfIds);
  }

  void deleteRoute(String id){
    listOfIds = listOfIds.where((value){ return value != id;}).toList();
    settingsService.saveRoutesIds(listOfIds);
    listOfIds = settingsService.loadRoutesIds();
  }

  ///
  /// Get route info
  ///
  RouteInfo? getRouteInfo(String id){
    final ret = settingsService.loadRouteInfo(id);
    return ret;
  }

  List<RouteInfo> getRoutes(){
    List<RouteInfo> ret = [];

    for(final id in listOfIds){
      ret.add(settingsService.loadRouteInfo(id)!);
    }

    return ret;
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

  // Stream<>

  ///
  /// Send here the new gps counter
  ///
  void updateCurrentGpsCounter(GpsInfo? gps_counter) {
    if (gps_counter == null) {
      debugPrint("updateCurrentGpsCounter: gps_counter is null");
      return;
    } else {
      currentGpsCounterStream.sink.add(gps_counter);
    }
  }

  ///
  /// Get the stream controller for gps counter
  ///
  Stream<GpsInfo> getCurrentGpsCounterStream() {
    return currentGpsCounterStream.stream;
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
      if(expanded){
        updateCurrentMapFakeOffset(0.03);
      }
      else{
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
  /// Send Battery Info
  ///
  void updateBatteryInfo(BatteryInfo? battInfo) {
    if (battInfo == null) {
      debugPrint("updateBatteryInfo: battInfo is null");
      return;
    } else {
      currentBatteryInfoStream.sink.add(battInfo);
    }
  }

  ///
  /// Get
  ///
  Stream<BatteryInfo> getBatteryInfoStream() {
    return currentBatteryInfoStream.stream;
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
