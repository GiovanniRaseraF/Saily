// Actual app
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:saily/settings/settings_controller.dart';
import 'package:saily/user/boat_widget.dart';
import 'package:saily/utils/saily_utils.dart';
import 'package:saily/utils/saily_colors.dart';

class UserView extends StatefulWidget {
  UserView({super.key, required this.settingsController, required this.onLogout});

  final String title = "user";
  SettingsController settingsController;

  void Function() onLogout;

  @override
  State<UserView> createState() =>
      _UserViewState(settingsController: settingsController, onLogout: onLogout);
}

class _UserViewState extends State<UserView> {
  _UserViewState({required this.settingsController, required this.onLogout});

  SettingsController settingsController;

  void Function() onLogout;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("User"), backgroundColor: Colors.white,),
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
                height: gCtxH() * 0.2,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("Giovanni Rasera"),
                      Text("g.rasera@gmail.com"),
                      SizedBox(
                          width: gCtxW() * 0.9,
                          child: FloatingActionButton(
                              heroTag: "logout",
                              child: Text(
                                "Logout",
                                style: TextStyle(color: Colors.white),
                              ),
                              backgroundColor: SailyBlue,
                              elevation: 10,
                              onPressed: () {
                                settingsController.logout();
                                Navigator.pop(context);
                                onLogout();
                                print("Log out from account");
                              }))
                    ],
                  ),
                )),
            Divider(),
            SizedBox(
              //height: gCtxH() * 0.1,
              child: Text("Boats"),
            ),
            SizedBox(
              height: gCtxH() * 0.5,
              child: Center(
                child: SingleChildScrollView(
                  child: Column(children: [
                    BoatWidget(), 
                    //BoatWidget(), 
                    // BoatWidget(), 
                    // BoatWidget(), 
                    // BoatWidget(), 
                  ]),
                ),
              ),
            ),
            SizedBox(
                width: gCtxW() * 0.9,
                child: FloatingActionButton(
                  heroTag: "add_new_boat",
                    child: Text(
                      "Add New Boat",
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: SailyBlue,
                    elevation: 10,
                    onPressed: () {
                      print("Add New Boat");
                    })),
          ],
        ));
  }
}
