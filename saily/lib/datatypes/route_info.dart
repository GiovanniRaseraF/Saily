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
}
