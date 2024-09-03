import 'package:saily/datatypes/boat_info.dart';

class UserInfo {
  UserInfo({required this.email, required this.username, required this.password});
  String username = "";
  String email = "";
  String password = "";

  List<BoatInfo> boats = [];

  void addBoat(BoatInfo newBoat){
    boats.add(newBoat);
  }

  String toJSONString(){
    return """{
      "username" : "$username",
      "email" : "$email",
      "password" : "$password",
      "boats" : []
    }
    """;
  }
}