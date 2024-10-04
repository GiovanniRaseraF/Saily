// Actual app
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:saily/datatypes/user_info.dart';
import 'package:saily/main.dart';
import 'package:saily/register/register_view.dart';
import 'package:saily/settings/settings_controller.dart';
import 'package:saily/boats/boat_widget.dart';
import 'package:saily/utils/saily_utils.dart';
import 'package:saily/utils/saily_colors.dart';

class LoginView extends StatefulWidget {
  LoginView(
      {super.key, required this.settingsController, required this.onLogin});

  final String title = "login";
  SettingsController settingsController;

  void Function() onLogin;

  @override
  State<LoginView> createState() =>
      _LoginViewState(settingsController: settingsController, onLogin: onLogin);
}

class _LoginViewState extends State<LoginView> {
  _LoginViewState({required this.settingsController, required this.onLogin}){
    homePage = MyHomePage(
      title: "Home Page",
      settingsController: this.settingsController,
      onLogout : (){setState(() {});}
    ); 

  }
  late Widget homePage;
  SettingsController settingsController;

  
  void Function() onLogin;
  @override
  Widget build(BuildContext context) {
    //print(settingsController.getUsername());
    //print(settingsController.getPassword());
    // check login

    if(settingsController.canUserLogin(settingsController.getUsername(), settingsController.getPassword())){
      return homePage;
    }

    //print("You Need to login");
    // return login page
    
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
              height: gCtxH() * 0.70,
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
                          Divider(color: Colors.transparent),
                          Text("Welcome to", style: TextStyle(fontSize: 20)),
                          Text("Saily", style: TextStyle(fontSize: 50))
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
                              onChanged: (value) {
                                settingsController.setUsername(value);
                                //print(settingsController.getUsername());
                                },
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
                              obscureText: true,
                              enableSuggestions: false,
                              autocorrect: false,
                              onChanged: (value) {
                                settingsController.setPassword(value);
                                //print(settingsController.getPassword());
                                },
                            ),
                          ),
                          Divider(
                            color: Colors.transparent,
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
                                    UserInfo? user = settingsController.getUser(settingsController.getUsername(), settingsController.getPassword());
                                    if(user == null){
                                      print("User ${settingsController.getUsername()}, ${settingsController.getPassword()} does not exist");
                                    }else{
                                      settingsController.login(settingsController.getUsername(), settingsController.getPassword());
                                      setState(() {
                                      });
                                    }
                                  }))
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              height: gCtxH() * 0.01,
              width: gCtxW() * 0.9,
            ),
            Container(
              height: gCtxH() * 0.23,
              width: gCtxW() * 0.9,
              child: Center(
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
                                  "New Here ?",
                                  style: TextStyle(fontSize: 15),
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
                                          print("Register");
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    RegisterView(
                                                        settingsController:
                                                            settingsController)),
                                          );
                                        }))
                              ],
                            ),
                          ),
                        ])),
              ),
            ),
            
          ],
        ),
      ],
    ));
  }
  
  // try to login
  
}
