// Actual app
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:saily/addnewboat/addnewboat_view.dart';
import 'package:saily/boats/boats_view.dart';
import 'package:saily/boats/selected_boat_view.dart';
import 'package:saily/datatypes/boat_info.dart';
import 'package:saily/datatypes/user_info.dart';
import 'package:saily/settings/settings_controller.dart';
import 'package:saily/boats/boat_widget.dart';
import 'package:saily/user/user_controller.dart';
import 'package:saily/user/user_widget.dart';
import 'package:saily/utils/saily_utils.dart';
import 'package:saily/utils/saily_colors.dart';
import 'package:saily/utils/utils.dart';
import 'package:saily/widgets/fract_box.dart';

class UserView extends StatefulWidget {
  UserView(
      {super.key, required this.settingsController, required this.onLogout});

  final String title = "user";
  SettingsController settingsController;

  void Function() onLogout;

  @override
  State<UserView> createState() => _UserViewState(
      settingsController: settingsController, onLogout: onLogout);
}

class _UserViewState extends State<UserView> {
  _UserViewState({required this.settingsController, required this.onLogout});

  SettingsController settingsController;

  void Function() onLogout;

  @override
  Widget build(BuildContext context) {
    UserInfo? currentUser = settingsController.getLoggedUser();

    return OrientationBuilder(builder: (c, or) {
      var w = scaleW(c, 1);
      var h = scaleH(c, 0.45);

      if (or == Orientation.portrait || true) {
        return Scaffold(
            appBar: AppBar(
              title: Text("User"),
              backgroundColor: Colors.white,
            ),
            backgroundColor: Colors.white,
            body: Center(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Card(
                        elevation: 10,
                        color: Colors.white,
                        child: UserWidget(
                            userInfo: currentUser!,
                            onLogout: () {
                              settingsController.logout();
                              Navigator.pop(context);
                              onLogout();
                              print("Log out from account");
                            })),
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    // boats
                    SizedBox(
                        width: 100,
                        child: Card(
                          child: FloatingActionButton(
                              heroTag: "boats",
                              child: Text(
                                "Boats",
                                style: TextStyle(color: Colors.white),
                              ),
                              backgroundColor: SailyBlue,
                              elevation: 10,
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => BoatsView(
                                            settingsController:
                                                settingsController)));
                              }),
                        )),
                    // logout
                    SizedBox(
                        width: 100,
                        child: Card(
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
                              }),
                        )),
                  ]),
                  Divider(),

                  SelectedBoatWidget(info:BoatInfo(name: "NoBoat", id: "0x0"))
                ],
              ),
            ));
      } else {
        return Scaffold(
            body: Row(
          children: [],
        ));
      }
    });
  }
}
