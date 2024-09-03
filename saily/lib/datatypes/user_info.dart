import 'package:saily/datatypes/boat_info.dart';

class UserInfo {
  String username = "";
  String password = "";

  List<BoatInfo> boats = [];

  void addBoat(BoatInfo newBoat){
    boats.add(newBoat);
  }

  String toJSONString(){
    return "";
  }
}