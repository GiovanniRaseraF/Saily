import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:saily/datatypes/route_info.dart';
import 'package:saily/datatypes/user_info.dart';
import 'package:saily/main.dart';
import 'package:saily/settings/fake_server.dart';
import 'package:saily/settings/settings_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:latlong2/latlong.dart';

class SettingsService extends CacheProvider {
  SettingsService({required this.sharePreferences, required this.server});

  SharedPreferences sharePreferences;
  FakeServer server;

  void addRouteToUser(String username, String password, RouteInfo newRoute){
    server.addRouteToUser(username, password, newRoute);
  }

  bool canAddUser(UserInfo newUser){
    return server.canAddUser(newUser);
  }

  UserInfo? loadUser(String username, String password){
    return server.getUser(username, password);
  }

  void saveUser(UserInfo user){
    server.updateUser(user);
  }

  bool canUserLogin(String username, String password){
    return server.canUserLogin(username, password);
  }


  final String USERNAME = "USERNAME";
  final String PASSwORD = "PASSWORD";

  String loadUsername(){
    String? ret = sharedPreferences.getString(USERNAME);
    if(ret == null){
      setUsername("");
      return "";
    };
    return ret!;
  }

  String loadPassword(){
    String? ret = sharedPreferences.getString(PASSwORD);
    if(ret == null){
      setPassword("");
      return "";
    }
    return ret!;
  }

  void setUsername(String user){
    sharePreferences.setString(USERNAME, user);
  }
  
  void setPassword(String pass){
    sharePreferences.setString(PASSwORD, pass);
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
