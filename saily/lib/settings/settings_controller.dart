import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:saily/datatypes/battery_info.dart';
import 'package:saily/datatypes/gps_types.dart';
import 'package:saily/settings/settings_service.dart';
import 'package:latlong2/latlong.dart';

class SettingsController extends ChangeNotifier {
  SettingsController({required this.settingsService}) {
    // create a broadcast stream
    currentBoatPositionStream = StreamController<LatLng>.broadcast();
    currentGpsCounterStream = StreamController<GpsCountType>.broadcast();
    currentBatteryInfoStream = StreamController<BatteryInfo>.broadcast();

    // map
    followMapRotationStream = StreamController<bool>.broadcast();
    expandTileStream = StreamController<bool>.broadcast();
    currentMapFakeOffsetStream = StreamController<double>.broadcast();

    // current off set value

  }

  // service
  SettingsService settingsService;

  ///
  /// Boat info
  ///
  late String selectedBoatdId;
  late StreamController<LatLng> currentBoatPositionStream;
  late StreamController<GpsCountType> currentGpsCounterStream;
  late StreamController<BatteryInfo> currentBatteryInfoStream;

  // map
  late StreamController<bool> followMapRotationStream;
  late StreamController<bool> expandTileStream;
  late StreamController<double> currentMapFakeOffsetStream;

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
  /// Send here the new gps counter
  ///
  void updateCurrentGpsCounter(GpsCountType? gps_counter) {
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
  Stream<GpsCountType> getCurrentGpsCounterStream() {
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
