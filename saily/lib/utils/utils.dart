///
/// author: Giovanni Rasera
/// Just functions with some usefull stuff
///

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'dart:io';

double scaleW(BuildContext c, double scale){
  return MediaQuery.of(c).size.width * scale;
}

double scaleH(BuildContext c, double scale){
  return MediaQuery.of(c).size.height * scale;
}

// just read file
String read_file({required String path}) => File("$path").readAsStringSync();

class Saily{
  final homePosition = LatLng(45.9034078,12.1159257);
}

class Styles{
  Styles();
  Radius round = Radius.circular(80);
  RoundedRectangleBorder round_shape = RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20)),);

  Color primary_color = Color.fromARGB(255, 255, 255, 255);
  Color primary_2_color = Colors.blueGrey;
  //static Color primary_2_color = Colors.blueGrey;
  Color secondary_color = Colors.blueAccent.shade200;

  Color hm_green = Color.fromARGB(0, 44, 123, 12);
}

class StylesLight extends Styles {
  StylesLight(){
    super.primary_color = Color.fromARGB(255, 255, 255, 255);
    super.primary_2_color = Colors.blueGrey;
    //static Color primary_2_color = Colors.blueGrey;
    super.secondary_color = Colors.blueAccent.shade200;

    super.hm_green = Color.fromARGB(0, 44, 123, 12); 
  }
}

class StylesDark extends Styles {
  StylesDark(){
    primary_color = Color.fromARGB(255, 42, 41, 41);
    primary_2_color = Colors.blueGrey;

    secondary_color = Colors.orangeAccent.shade700;
    hm_green = Color.fromARGB(0, 44, 123, 12);
  }
}