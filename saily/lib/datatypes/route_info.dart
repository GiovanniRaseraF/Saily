import 'dart:convert';

import 'package:latlong2/latlong.dart';

class RouteInfo {
  RouteInfo({required this.name, required this.positions, required this.from, required this.to}){
    id = to;
  }

  String id = "";
  String name = "";
  List<LatLng> positions = [];
  String from; 
  String to; 

  String listToJSONString(List<LatLng> pos) {
    if (pos.length == 0) return "";

    String ret = "";
    for (final p in pos) {
      ret += """{"lat": ${p.latitude}, "lon": ${p.longitude}},""";
    }
    return ret.substring(0, ret.length-1);
  }

  String toJSONString() {
    final p = listToJSONString(positions);
    String ret = """{
      "id" : "$to",
      "name" : "${name}",
      "from" : "$from",
      "to" : "$to",
      "positions" : [
        ${p}
      ]
    } 
      """;
    return ret;
  }

  // From the json string saved
  static RouteInfo? fromJSONString(String json){
    try{
      final parsed = jsonDecode(json);
      return RouteInfo.fromJSONDynamic(parsed);
    }on Exception {
      return null; 
    }
  }
  
  // From the json dynamic
  static RouteInfo? fromJSONDynamic(dynamic json){
    try{
      String name = json["name"];
      String id = json["id"];
      String from = json["from"];
      String to = json["to"];
      List<dynamic> positions = json["positions"] as List<dynamic>;

      // load positioning
        List<LatLng> loadedPos = [];
        for (final p in positions) {
          var ln = LatLng(p["lat"], p["lon"]);
          loadedPos.add(ln);
        }

      return RouteInfo(name: name, from: from, to: to, positions: loadedPos);
    }on Exception {
      return null; 
    }
  }
}
