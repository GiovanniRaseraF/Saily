import 'dart:convert';

import 'package:latlong2/latlong.dart';
import 'package:saily/datatypes/electricmotor_info.dart';
import 'package:saily/datatypes/highpowerbattery_info.dart';
import 'package:saily/datatypes/nmea2000_info.dart';

class RouteInfo {
  RouteInfo({required this.name, required this.positions, required this.from, required this.to, required this.hpibInfo, required this.emInfo, required this.vtgInfo}){
    id = to;
  }

  String id = "";
  String name = "";

  // Infos for recostructing
  List<LatLng> positions = [];
  List<HighpowerbatteryInfo> hpibInfo = [];
  List<ElectricmotorInfo> emInfo = [];
  List<VTGInfo> vtgInfo = [];

  String from; 
  String to; 

  String listPosToJSONString(List<LatLng> pos) {
    if (pos.length == 0) return "";

    String ret = "";
    for (final p in pos) {
      ret += """{"lat": ${p.latitude}, "lon": ${p.longitude}},""";
    }
    return ret.substring(0, ret.length-1);
  }

  String listToJSONString<T>(List<T> pos) {
    if (pos.length == 0) return "";

    String ret = "";
    for (final p in pos) {
      ret += """${p.toString()},""";
    }
    return ret.substring(0, ret.length-1);
  }

  String toJSONString() {
    final positionsStr = listPosToJSONString(positions);
    final hpInfoStr = listToJSONString<HighpowerbatteryInfo>(hpibInfo);
    final emiInfoStr = listToJSONString<ElectricmotorInfo>(emInfo);
    final vtgInfoStr = listToJSONString<VTGInfo>(vtgInfo);

    String ret = """{
      "id" : "$to",
      "name" : "${name}",
      "from" : "$from",
      "to" : "$to",
      "positions" : [
        ${positionsStr}
      ],
      "hpibInfo" : [
        $hpInfoStr
      ],
      "emInfo" : [
        $emiInfoStr
      ],
      "vtgInfo" : [
        $vtgInfoStr
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

  static List<T> fromJSONDynamicOrEmptyList<T>(dynamic json, String jsonFieldName, T Function(dynamic t) fromJSONDynamicToT) {
    try{
      dynamic list = json[jsonFieldName];
      List<dynamic> listEstract = list as List<dynamic>;
      List<T> ret = [];
      for(final t in listEstract){
        T val = fromJSONDynamicToT(t);
        ret.add(val);
      }
      return ret;
    }on Exception {
      return [];
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

      // Load other info
      List<HighpowerbatteryInfo> hpibInfo = fromJSONDynamicOrEmptyList<HighpowerbatteryInfo>(json, "hpibInfo", (dynamic t){
        return HighpowerbatteryInfo.fromJSONDynamic(t)!;
      });
      List<ElectricmotorInfo> emInfo = fromJSONDynamicOrEmptyList<ElectricmotorInfo>(json, "emInfo", (dynamic t){
        return ElectricmotorInfo.fromJSONDynamic(t)!;
      });
      List<VTGInfo> vtgInfo = fromJSONDynamicOrEmptyList<VTGInfo>(json, "vtgInfo", (dynamic t){
        return VTGInfo.fromJSONDynamic(t)!;
      });

      return RouteInfo(name: name, from: from, to: to, positions: loadedPos, hpibInfo: hpibInfo, emInfo: emInfo, vtgInfo: vtgInfo);
    }on Exception {
      return null; 
    }
  }
}
