import 'dart:convert';

class BoatInfo {
  BoatInfo({required this.name});
  String name = "";
  
  String toJSONString(){
    return """{
      "name" : "${name}"
    }
    """;
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
      String name = json["name"];

      return BoatInfo(name: name);
    }on Exception {
      return null; 
    }
  }
}