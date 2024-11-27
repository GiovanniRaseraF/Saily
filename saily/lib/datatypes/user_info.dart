import 'dart:convert';

import 'package:saily/datatypes/boat_info.dart';
import 'package:saily/datatypes/route_info.dart';

class UserInfo {
  UserInfo(
      {
      required this.username,
      required this.routes});
  String username = "";

  List<RouteInfo> routes = [];

  

  void addRoute(RouteInfo newRoute) {
    routes.add(newRoute);
  }

  String routesToJSONString() {
    String ret = "";
    if (routes.length == 0) return "";

    for (final r in routes) {
      ret += r.toJSONString() + ",";
    }

    return ret.substring(0, ret.length - 1);
  }

  String toJSONString() {
    return """{
      "username" : "$username",
      "routes" : [
        ${routesToJSONString()}
      ]
    }
    """;
  }

  // Create the user
  static UserInfo? fromJSONString(String json) {
    try {
      final parsed = jsonDecode(json);
      return UserInfo.fromJSONDynamic(parsed);
    } on Exception {
      return null;
    }
  }

  // Create the user
  static UserInfo? fromJSONDynamic(dynamic json) {
    try {
      String username = json["username"];
      List<dynamic> routesDynamic = json["routes"];
      List<BoatInfo> boats = [];
      List<RouteInfo> routes = [];

      for (dynamic ryn in routesDynamic) {
        final route = RouteInfo.fromJSONDynamic(ryn);
        if (route != null) {
          routes.add(route);
        }
      }

      return UserInfo(
          username: username,
          routes: routes);
    } on Exception {
      return null;
    }
  }
}
