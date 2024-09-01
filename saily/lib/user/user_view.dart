// Actual app
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:saily/settings/settings_controller.dart';
import 'package:saily/utils/saily_utils.dart';
import 'package:saily/utils/utils.dart';
import 'package:saily/utils/saily_colors.dart';

class UserView extends StatefulWidget {
  UserView({super.key, required this.settingsController});

  final String title = "user";
  SettingsController settingsController;

  @override
  State<UserView> createState() =>
      _UserViewState(settingsController: settingsController);
}

class _UserViewState extends State<UserView> {
  _UserViewState({required this.settingsController});

  SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("User")),
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
                              child: Text(
                                "Logout",
                                style: TextStyle(color: Colors.white),
                              ),
                              backgroundColor: SailyBlue,
                              elevation: 10,
                              onPressed: () {
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
                    SizedBox(
                        height: 200,
                        width: gCtxW() * 0.9,
                        child: Card(
                          elevation: 10,
                          child: Text("Boat 1"),
                        )),
                    SizedBox(
                        height: 200,
                        width: gCtxW() * 0.9,
                        child: Card(
                          elevation: 10,
                          child: Text("Boat 1"),
                        )),
                    SizedBox(
                        height: 200,
                        width: gCtxW() * 0.9,
                        child: Card(
                          elevation: 10,
                          child: Text("Boat 1"),
                        )),
                    SizedBox(
                        height: 200,
                        width: gCtxW() * 0.9,
                        child: Card(
                          elevation: 10,
                          child: Text("Boat 1"),
                        )),
                    SizedBox(
                        height: 200,
                        width: gCtxW() * 0.9,
                        child: Card(
                          elevation: 10,
                          child: Text("Boat 1"),
                        )),
                    SizedBox(
                        height: 200,
                        width: gCtxW() * 0.9,
                        child: Card(
                          elevation: 10,
                          child: Text("Boat 1"),
                        )),
                  ]),
                ),
                // SizedBox(
                //     width: gCtxW() * 0.9,
                //     child: FloatingActionButton(
                //         child: Text(
                //           "Add New Boat",
                //           style: TextStyle(color: Colors.white),
                //         ),
                //         backgroundColor: SailyBlue,
                //         elevation: 10,
                //         onPressed: () {
                //           print("Add New Boat");
                //         }))
                // ]),
              ),
            ),
            SizedBox(
                width: gCtxW() * 0.9,
                child: FloatingActionButton(
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
