import 'package:saily/tracks/gpx_trips.dart';
import 'package:latlong2/latlong.dart';
import 'package:xml/xml.dart';
import 'dart:io';

class FakeData {
  FakeData();

  String rawdata = "";
  int counter = 0;
  late XmlDocument document;
  late List<LatLng> positions;

  void load_parse(String trip) async {
    rawdata = trip;
    document = XmlDocument.parse(rawdata);

    // estract data
    positions = document.findAllElements("wpt").map((wpt){
       return LatLng(double.parse(wpt.getAttribute("lat") as String), double.parse(wpt.getAttribute("lon") as String));
     }).toList();
    final toadd = document.findAllElements("trkpt").map((rtept){
       return LatLng(double.parse(rtept.getAttribute("lat") as String), double.parse(rtept.getAttribute("lon") as String));
    }).toList();

    positions.addAll(toadd);
  }

  LatLng getNext(){
    int pos = counter;
    counter += 1;
    counter %= positions.length;

    return positions[pos];
  }
}