import 'dart:convert';

class BoatInfo {
  BoatInfo({required this.name, required this.id});
  String name = "";
  String id = "";
  
  String toJSONString(){
    return """{
      "name" : "${name}",
      "id" : "${id}"
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
      String name = "";//json["name"];
      String id = "";//json["boat_id"];

      return BoatInfo(name: name, id: id);
    }on Exception {
      return null; 
    }
  }
}