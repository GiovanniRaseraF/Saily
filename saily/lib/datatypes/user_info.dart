import 'dart:convert';

import 'package:saily/datatypes/boat_info.dart';

class UserInfo {
  UserInfo({required this.email, required this.username, required this.password, required this.boats});
  String username = "";
  String email = "";
  String password = "";

  List<BoatInfo> boats = [];

  void addBoat(BoatInfo newBoat){
    boats.add(newBoat);
  }

  String boatsToJSONString(){
    String ret = "";
    if(boats.length == 0) return "";

    for(final b in boats){
      ret += b.toJSONString() + ",";
    }

    return ret.substring(0, ret.length-1);
  }

  String toJSONString(){
    return """{
      "username" : "$username",
      "email" : "$email",
      "password" : "$password",
      "boats" : [
        ${boatsToJSONString()}
      ]
    }
    """;
  }

  // Create the user
  static UserInfo? fromJSONString(String json){
    try{
      final parsed = jsonDecode(json);
      return UserInfo.fromJSONDynamic(parsed);
    }on Exception {
      return null; 
    }  
  }

  // Create the user
  static UserInfo? fromJSONDynamic(dynamic json){
     try{
      String username = json["username"];
      String email = json["email"];
      String password = json["password"];
      List<dynamic> boatsDynamic = json["boats"];
      List<BoatInfo> boats=[];
      for(dynamic dyn in boatsDynamic){
        final boat = BoatInfo.fromJSONDynamic(dyn);
        if(boat != null){
          boats.add(boat);
        }
      }
      return UserInfo(username: username, email: email, password: password, boats: boats);
    }on Exception {
      return null; 
    }
  }
}