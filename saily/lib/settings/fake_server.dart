import 'dart:convert';

import 'package:saily/datatypes/boat_info.dart';
import 'package:saily/datatypes/route_info.dart';
import 'package:saily/datatypes/user_info.dart';
import 'package:share/share.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String USERS_STORE = "USERS_STORE";

UserInfo adminDefault = UserInfo(
    email: "admin@admin.com",
    username: "admin",
    password: "admin",
    routes: [
      RouteInfo(name: "Giro con alice", positions: [
        LatLng( 43.52120256331884,  7.056244213486337),
        LatLng(43.52120256331884,  7.056972511028611),
        LatLng( 43.52120256331884,  7.057549079916243),
        LatLng( 43.521158554734676,7.058216685996662),
        LatLng( 43.52100452443738, 7.058914637807968),
        LatLng( 43.52091650694805, 7.059430515233745),
        LatLng( 43.52087249815524, 7.060007084121378),
        LatLng( 43.52078448047333, 7.060735381663653),
        LatLng( 43.52071846712764, 7.061888519438921),
        LatLng( 43.52071846712764, 7.062586471250265),
        LatLng( 43.52065245370971, 7.063436151716252),
        LatLng( 43.52043240846161, 7.06395202914199),
        LatLng( 43.520168353104566, 7.064528598029623),
        LatLng( 43.51986028706073,  7.064953438262616),
        LatLng( 43.51972825827471,  7.06528724130282),
      ], from: DateTime.now().toString(), to: DateTime.now().toString()),
    ],
    boats: [
      BoatInfo(boat_name: "Angelica", boat_id: "0x0000"),
      BoatInfo(boat_name: "Marta", boat_id: "0x0001"),
      BoatInfo(boat_name: "Lorena", boat_id: "0x0002"),
    ]);

class FakeServer {
  FakeServer({required this.preferences});

  SharedPreferences preferences;
  List<UserInfo> users = [];

  void addRouteToUser(String username, String password, RouteInfo newRoute){
    bool can = canUserLogin(username, password);
    if(can){
      var user = getUser(username, password);

      user!.addRoute(newRoute);
      updateUser(user);
    }
  }

  // First operation
  void loadUsers() {
    String? usersLoadedString = preferences.getString(USERS_STORE);
    if (usersLoadedString == null) {
      // create default user string
      String defaultToStore = "[" + (adminDefault.toJSONString()) + "]";
      preferences.setString(USERS_STORE, defaultToStore);
      usersLoadedString = defaultToStore;
    }

    // Decode string
    List<dynamic> usersDynamic = jsonDecode(usersLoadedString) as List<dynamic>;

    // Load each user
    for (final u in usersDynamic) {
      UserInfo? newUser = UserInfo.fromJSONDynamic(u);
      if (newUser != null) {
        users.add(newUser);
      }
    }
  }

  void saveUsers(){
    preferences.setString(USERS_STORE, toJSONString());
  }

  String usersToJSONString(){
    String ret = "";
    if(users.length == 0) return "";

    for(final u in users){
      ret += u.toJSONString() + ",";
    }

    return ret.substring(0, ret.length-1);
  }


  String toJSONString(){
    String ret = "";
    ret += "[" + usersToJSONString() + "]";
    return ret;
  }

  bool canUserLogin(String username, String password){
    for(var u in users){
      if(u.username == username && u.password == password){
        return true;
      }
    }

    return false;
  }

  UserInfo? getUser(String username, String password){
    for(var u in users){
      if(u.username == username && u.password == password){
        return u;
      }
    }

    return null;
  }

  void deleteUser(String username, String password){
    List<UserInfo> newUsers = [];
    for(var u in users){
      if(u.username == username && u.password == password){
        // dont add to new list 
      }else{
        newUsers.add(u);
      }
    }

    users = newUsers;
    saveUsers();
  }

  bool canAddUser(UserInfo newUser){
    for(var u in users){
      if(u.username == newUser.username ){
        return false;
      }
    }

    return true;
  }

  void addUser(UserInfo newUser){
    if(canAddUser(newUser)){
      users.add(newUser);
      saveUsers();
    }
  }

  void updateUser(UserInfo userToUpdate){
    deleteUser(userToUpdate.username, userToUpdate.password);
    addUser(userToUpdate);
  }
}
