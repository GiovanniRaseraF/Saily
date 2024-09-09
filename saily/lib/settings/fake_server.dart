import 'dart:convert';

import 'package:saily/datatypes/boat_info.dart';
import 'package:saily/datatypes/route_info.dart';
import 'package:saily/datatypes/user_info.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String USERS_STORE = "USERS_STORE";

UserInfo adminDefault = UserInfo(
    email: "admin@admin.com",
    username: "admin",
    password: "admin",
    routes: [
      RouteInfo(name: "Giro con alice", positions: [], from: DateTime.now().toString(), to: DateTime.now().toString()),
      RouteInfo(name: "Giro con marco", positions: [], from: DateTime.now().toString(), to: DateTime.now().toString()),
      RouteInfo(name: "Giro con federico", positions: [], from: DateTime.now().toString(), to: DateTime.now().toString()),
    ],
    boats: [
      BoatInfo(name: "Angelica", id: "0x0000"),
      BoatInfo(name: "Marta", id: "0x0001"),
      BoatInfo(name: "Lorena", id: "0x0002"),
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
        print(u.toJSONString());
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
