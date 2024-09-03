// Actual app
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:saily/settings/settings_controller.dart';
import 'package:saily/user/boat_widget.dart';
import 'package:saily/utils/saily_utils.dart';
import 'package:saily/utils/saily_colors.dart';

class RegisterView extends StatefulWidget {
  RegisterView(
      {super.key, required this.settingsController});

  final String title = "register";
  SettingsController settingsController;


  @override
  State<RegisterView> createState() =>
      _RegisterViewState(settingsController: settingsController);
}

class _RegisterViewState extends State<RegisterView> {
  _RegisterViewState({required this.settingsController});

  SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Positioned.fill(
            child: Image.asset(
          "images/water.png",
          fit: BoxFit.cover,
        )),
        Column(
          children: [
            Container(
              height: gCtxH() * 0.05,
              color: Colors.transparent,
            ),
            Container(
              height: gCtxH() * 0.60,
              width: gCtxW() * 0.9,
              child: Card(
                elevation: 10,
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        children: [
                          Divider(
                            color: Colors.transparent,
                          ),
                          Text(
                            "Happy to have you !",
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        children: [
                          SizedBox(
                            child: TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Username',
                              ),
                              onChanged: (value) {},
                            ),
                          ),
                          Divider(
                            color: Colors.transparent,
                          ),
                          SizedBox(
                            child: TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Email',
                              ),
                              onChanged: (value) {},
                            ),
                          ),
                          Divider(
                            color: Colors.transparent,
                          ),
                          SizedBox(
                            child: TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Password',
                              ),
                              onChanged: (value) {},
                            ),
                          ),
                          Divider(
                            color: Colors.transparent,
                          ),
                          SizedBox(
                            child: TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Repeat Password',
                              ),
                              onChanged: (value) {},
                            ),
                          ),
                          Divider(
                            color: Colors.transparent,
                          ),
                          SizedBox(
                              width: gCtxW() * 0.9,
                              child: FloatingActionButton(
                                  heroTag: "register",
                                  child: Text(
                                    "Register",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: SailyBlue,
                                  elevation: 10,
                                  onPressed: () {
                                    Navigator.pop(context);
                                  }))
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              height: gCtxH() * 0.08,
              width: gCtxW() * 0.9,
            ),
            Container(
              height: gCtxH() * 0.2,
              width: gCtxW() * 0.9,
              child: Card(
                  elevation: 10,
                  color: Colors.white,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Column(
                            children: [
                              Divider(
                                color: Colors.transparent,
                              ),
                              Text(
                                "Already a member ?",
                                style: TextStyle(fontSize: 20),
                              ),
                              SizedBox(
                                  width: gCtxW() * 0.9,
                                  child: FloatingActionButton(
                                      heroTag: "login",
                                      child: Text(
                                        "Login",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      backgroundColor: SailyBlue,
                                      elevation: 10,
                                      onPressed: () {
                                        Navigator.pop(context);
                                      }))
                            ],
                          ),
                        ),
                      ])),
            ),
            Container(
              height: gCtxH() * 0.01,
              color: Colors.transparent,
            ),
          ],
        ),
      ],
    ));
  }
}
