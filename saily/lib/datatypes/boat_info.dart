import 'dart:convert';

class BoatInfo {
  BoatInfo({required this.boat_name, required this.boat_id});
  String boat_name = "";
  String boat_id = "";
  
  String toJSONString(){
    return """{
      "boat_name" : "${boat_name}",
      "boat_id" : "${boat_id}"
    }""";
  }
  // From the json string saved
  static BoatInfo? fromJSONString(String json){
    try{
      final parsed = jsonDecode(json);
      return BoatInfo.fromJSONDynamic(parsed);
    }on Exception {
      return null; 
    }
  }
  
  // From the json dynamic
  static BoatInfo? fromJSONDynamic(dynamic json){
    try{
      String name = json["boat_id"];
      String id = json["boat_id"];

      return BoatInfo(boat_name: name, boat_id: id);
    }on Exception {
      return null; 
    }
  }
}