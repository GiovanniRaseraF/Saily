import 'package:latlong2/latlong.dart';

class RouteInfo {
  RouteInfo({required this.name, required this.positions});

  String name = "";
  List<LatLng> positions = [];

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
    "name" : "${name}",
    "positions" : [
      ${p}
    ]
    } 
    """;
    return ret;
  }
}
