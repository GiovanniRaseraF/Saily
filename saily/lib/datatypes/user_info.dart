import 'dart:convert';

import 'package:saily/datatypes/boat_info.dart';
import 'package:saily/datatypes/route_info.dart';

class UserInfo {
  UserInfo(
      {required this.email,
      required this.username,
      required this.password,
      required this.boats,
      required this.routes});
  String username = "";
  String email = "";
  String password = "";

  List<BoatInfo> boats = [];
  List<RouteInfo> routes = [];

  void addBoat(BoatInfo newBoat) {
    boats.add(newBoat);
  }

  void addRoute(RouteInfo newRoute) {
    routes.add(newRoute);
  }

  String boatsToJSONString() {
    String ret = "";
    if (boats.length == 0) return "";

    for (final b in boats) {
      ret += b.toJSONString() + ",";
    }

    return ret.substring(0, ret.length - 1);
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
      "email" : "$email",
      "password" : "$password",
      "boats" : [
        ${boatsToJSONString()}
      ],
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
      String email = json["email"];
      String password = json["password"];
      List<dynamic> boatsDynamic = json["boats"];
      List<dynamic> routesDynamic = json["routes"];
      List<BoatInfo> boats = [];
      List<RouteInfo> routes = [];

      for (dynamic dyn in boatsDynamic) {
        final boat = BoatInfo.fromJSONDynamic(dyn);
        if (boat != null) {
          boats.add(boat);
        }
      }

      for (dynamic ryn in routesDynamic) {
        final route = RouteInfo.fromJSONDynamic(ryn);
        if (route != null) {
          routes.add(route);
        }
      }

      return UserInfo(
          username: username,
          email: email,
          password: password,
          boats: boats,
          routes: routes);
    } on Exception {
      return null;
    }
  }
}
