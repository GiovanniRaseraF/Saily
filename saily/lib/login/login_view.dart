// Actual app
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:saily/main.dart';
import 'package:saily/register/register_view.dart';
import 'package:saily/settings/settings_controller.dart';
import 'package:saily/user/boat_widget.dart';
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

    if(settingsController.isLogged()){
      print("Try to Log in one second");
      // check if is logged in
      Future.delayed(Duration(microseconds: 500)).then((t){
        tryLogin(context);
      });
    }

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
                          Divider(color: Colors.transparent),
                          Text("Welcome to", style: TextStyle(fontSize: 20)),
                          Text("Saily", style: TextStyle(fontSize: 70))
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
                                hintText: 'Password',
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
                                  heroTag: "login",
                                  child: Text(
                                    "Login",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: SailyBlue,
                                  elevation: 10,
                                  onPressed: () {
                                    print("login");
                                    settingsController.login();

                                    // build
                                    tryLogin(context);
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
                                "New Here ?",
                                style: TextStyle(fontSize: 20),
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
            Container(
              height: gCtxH() * 0.01,
              color: Colors.transparent,
            ),
          ],
        ),
      ],
    ));
  }
  
  // try to login
  void tryLogin(BuildContext c) {
    bool canLogin = settingsController.isLogged();
      if (canLogin) {
        print("You can Login");
      } else {
        print("You CANNOT Login !");
      }

      // create homepage
      if (canLogin) {
        Navigator.push(
          c,
          MaterialPageRoute(
              builder: (context) => homePage),
        );
      }
    }
}
