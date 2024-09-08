import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:saily/datatypes/route_info.dart';
import 'package:saily/datatypes/user_info.dart';
import 'package:saily/settings/settings_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:latlong2/latlong.dart';

class SettingsService extends CacheProvider {
  SettingsService({required this.sharePreferences});

  SharedPreferences sharePreferences;


  UserInfo? loadUser(String username, String password){
    const String PREFIX = "USER_INFO";
    final userJson = getString(PREFIX);
    if(userJson == null) return null;
    
    var ret = UserInfo.fromJSONString(userJson);
    if(ret == null) return null;
    if(ret.username == username && ret.password == password) return ret;
  }

  void saveUser(UserInfo user){
    const String PREFIX = "USER_INFO";
    final save = user.toJSONString();
    setString(PREFIX, save);
  }

  /// 
  /// Check if logged
  /// 
  bool loadIsLogged(){
    const String PREFIX = "IS_LOGGED";
    final ret = getBool(PREFIX);
    if(ret == null){
      return false;
    }
    return ret;
  }

  ///
  /// Save logged state
  ///
  void saveLogged(bool newLogged){
    const String PREFIX = "IS_LOGGED";
    setBool(PREFIX, newLogged);
  }

  ///
  /// Save the route info
  ///
  void saveRouteInfo(String name, List<LatLng> positions, String from, String to) {
    const String PREFIX = "SINGLE_ROUTE_ID_";
    final toSave = RouteInfo(name: name, positions: positions, from: from, to: to);

    setString(PREFIX+toSave.id, toSave.toJSONString());
    print("Saved: ${name}");
  }

  ///
  /// Load the route info
  ///
  RouteInfo? loadRouteInfo(String id) {
    const String PREFIX = "SINGLE_ROUTE_ID_";
    String? recordInJSON = getString(PREFIX + id);

    if (recordInJSON == null) {
      return null;
    } else {
      try {
        final decoded = jsonDecode(recordInJSON);
        final pos = decoded["positions"] as List<dynamic>;

        // load positioning
        List<LatLng> loadedPos = [];
        for (final p in pos) {
          var ln = LatLng(p["lat"], p["lon"]);
          loadedPos.add(ln);
        }

        final from = decoded["from"] as String;
        final to = decoded["to"] as String;

        // return new positioning
        return RouteInfo(
            name: decoded["name"], positions: loadedPos, from: from, to: to);
      } on Exception {
        return null;
      }
    }
  }

  ///
  /// save the list of ids
  ///
  void saveRoutesIds(List<String> ids) {
    const String LISTOFIDSPREFIX = "LIST_OF_IDS_ROUTES";

    if (ids.length == 0) {
      setString(LISTOFIDSPREFIX, "[]");
    } else {
      String value = "[";
      for (final i in ids) {
        value += """"${i}",""";
      }
      value = value.substring(0, value.length - 1);
      value += "]";

      setString(LISTOFIDSPREFIX, value);
    }
  }

  ///
  /// Load the list of ids
  ///
  List<String> loadRoutesIds() {
    const String LISTOFIDSPREFIX = "LIST_OF_IDS_ROUTES";
    final listS = getString(LISTOFIDSPREFIX);
    if (listS == null) return [];

    try{
      final list = jsonDecode(listS) as List<dynamic>;
      List<String> ret = [];
      for(final l in list){
        ret.add(l as String);
      }

      return ret;
    }on Exception {
      return [];
    }
  }

  @override
  bool containsKey(String key) {
    return sharePreferences.containsKey(key);
  }

  @override
  bool? getBool(String key, {bool? defaultValue}) {
    bool? ret;
    ret = sharePreferences.getBool(key);

    if (ret == null) {
      if (defaultValue == null) {
        return false;
      } else {
        return defaultValue!;
      }
    }

    return ret;
  }

  @override
  double? getDouble(String key, {double? defaultValue}) {
    try {
      double? ret = sharePreferences.getDouble(key);
      if (ret == null) {
        throw Exception();
      }
      return ret;
    } on Exception {
      return defaultValue;
    }
  }

  @override
  int? getInt(String key, {int? defaultValue}) {
    try {
      int? ret = sharePreferences.getInt(key);
      if (ret == null) {
        throw Exception();
      }
      return ret;
    } on Exception {
      return defaultValue;
    }
  }

  @override
  Set getKeys() {
    return sharePreferences.getKeys();
  }

  @override
  String? getString(String key, {String? defaultValue}) {
    try {
      String? ret = sharePreferences.getString(key);
      if (ret == null) {
        throw Exception();
      }
      return ret;
    } on Exception {
      return defaultValue;
    }
  }

  @override
  T? getValue<T>(String key, {T? defaultValue}) {
    try {
      return sharePreferences.get(key) as T;
    } on Exception {
      return defaultValue;
    }
  }

  @override
  Future<void> init() async {
    print("Init");
  }

  @override
  Future<void> remove(String key) async {
    await sharePreferences.remove(key);
  }

  @override
  Future<void> removeAll() async {
    await sharePreferences.clear();
  }

  @override
  Future<void> setBool(String key, bool? value) async {
    if (value != null) {
      await sharePreferences.setBool(key, value);
    } else {
      debugPrint("setBool: cannot set $key to value = $value");
    }
  }

  @override
  Future<void> setDouble(String key, double? value) async {
    if (value != null) {
      await sharePreferences.setDouble(key, value);
    } else {
      debugPrint("setDouble: cannot set $key to value = $value");
    }
  }

  @override
  Future<void> setInt(String key, int? value) async {
    if (value != null) {
      await sharePreferences.setInt(key, value);
    } else {
      debugPrint("setInt: cannot set $key to value = $value");
    }
  }

  @override
  Future<void> setObject<T>(String key, T? value) async {
    debugPrint("SettingValue: $key : $value");
    switch (T) {
      case bool:
        await setBool(key, value as bool);
        break;
      case int:
        await setInt(key, value as int);
        break;
      case double:
        await setDouble(key, value as double);
        break;
      case String:
        await setString(key, value as String);
        break;
    }

    // if (T is int) {
    //   this.setInt(key, value as int);
    // }
    // if (T is double) {
    //   this.setDouble(key, value as double);
    // }
    // if (T is bool) {
    // }
    // if (T is String) {
    //   this.setString(key, value as String);
    // }
  }

  @override
  Future<void> setString(String key, String? value) async {
    if (value != null) {
      await sharePreferences.setString(key, value);
    } else {
      debugPrint("setInt: cannot set $key to value = $value");
    }
  }
}
