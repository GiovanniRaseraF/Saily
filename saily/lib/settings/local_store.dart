import 'dart:convert';

import 'package:saily/datatypes/boat_info.dart';
import 'package:saily/datatypes/route_info.dart';
import 'package:saily/datatypes/user_info.dart';
import 'package:share/share.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String USERS_STORE = "USERS_STORE";

class LocalStore {
  LocalStore({required this.preferences});

  SharedPreferences preferences;
  List<UserInfo> users = [];

  void addRouteToUser(String username, RouteInfo newRoute){
    bool can = canUserLogin(username);
    if(can){
      var user = getUser(username);

      user!.addRoute(newRoute);
      updateUser(user);
    }else{
      if(getUser(username)== null){
        addUser(UserInfo(username: username, routes: [newRoute]));
      }
    }

  }

  // First operation
  void loadUsers() {
    String? usersLoadedString = preferences.getString(USERS_STORE);
    if (usersLoadedString == null) {
      // create default user string
      String defaultToStore = "[" "]";
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

  bool canUserLogin(String username){
    for(var u in users){
      if(u.username == username){
        return true;
      }
    }

    return false;
  }

  UserInfo? getUser(String username){
    for(var u in users){
      if(u.username == username){
        return u;
      }
    }

    return null;
  }

  void deleteRoute(String idToDelete, String username){
    UserInfo? user = getUser(username);
    if(user == null) return;

    List<RouteInfo> newRoutes = [];
    for(final r in user.routes){
      if(r.id != idToDelete){
        newRoutes.add(r);
      }
    }

    UserInfo newUser = UserInfo(username: username, routes: newRoutes);
    updateUser(newUser);
  }

  void deleteUser(String username){
    List<UserInfo> newUsers = [];
    for(var u in users){
      if(u.username == username){
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
    deleteUser(userToUpdate.username);
    addUser(userToUpdate);
  }
}
