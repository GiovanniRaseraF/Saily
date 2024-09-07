import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:saily/datatypes/battery_info.dart';
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

    // logged
    logged = settingsService.loadIsLogged();
  }

  // Current User
  UserInfo? currentUser = null;
  
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

  // logged
  bool logged = false;


  UserInfo? loadUser(String email, String password){
    currentUser = settingsService.loadUser(email, password);
    return currentUser;
  }

  // On final app this serviceSerice will contact a server to check if 
  // you can login 
  void setLogged(bool value){
    logged = value;
    settingsService.saveLogged(logged);
  }

  void logout(){
    logged = false;
    if(currentUser != null){
      settingsService.saveUser(currentUser!);
      currentUser = null;
    }
    setLogged(logged);
  }

  void login(){
    logged = true;
    setLogged(logged);
  }

  bool isLogged(){
    logged = settingsService.loadIsLogged();
    return logged && currentUser != null;
  }


  // camera load
  CameraDescription getCamera(){
    return camera;
  }

  Future<void> loadDependeces() async {
    var cam = await availableCameras();
    camera = cam.first;
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
