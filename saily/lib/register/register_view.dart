// Actual app
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:saily/datatypes/user_info.dart';
import 'package:saily/settings/settings_controller.dart';
import 'package:saily/user/boat_widget.dart';
import 'package:saily/utils/saily_utils.dart';
import 'package:saily/utils/saily_colors.dart';

class RegisterView extends StatefulWidget {
  RegisterView({super.key, required this.settingsController});

  final String title = "register";
  SettingsController settingsController;

  @override
  State<RegisterView> createState() =>
      _RegisterViewState(settingsController: settingsController);
}

class _RegisterViewState extends State<RegisterView> {
  _RegisterViewState({required this.settingsController});

  SettingsController settingsController;

  String username = "";
  String email = "";
  String password = "";
  String repeatPassword = "";

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
                              onChanged: (value) {username = value;},
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
                              onChanged: (value) {email = value;},
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
                              onChanged: (value) {password = value;},
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
                              obscureText: true,
                              enableSuggestions: false,
                              autocorrect: false,
                              onChanged: (value) {repeatPassword = value;},
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
                                    if(username == ""){
                                      
                                    } else if (password == ""){

                                    }else if(password != repeatPassword){
                                      showAlertDialog(context);
                                    }else{
                                      UserInfo newUser = UserInfo(email: email, username: username, password: password, boats: [], routes: []);
                                      bool can = settingsController.canAddUser(newUser);
                                      if(can){
                                        settingsController.addUser(newUser);
                                        Navigator.pop(context);
                                      }else{
                                        // show you cannot add user
                                        showAlertUserAlreadyExistsDialog(context);
                                      }
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
            
          ],
        ),
      ],
    ));
  }

  // Cannot add user
  showAlertUserAlreadyExistsDialog(BuildContext context) {  
  // Create button  
  Widget okButton = SizedBox(
    width: gCtxW() * 0.9,
    child: FloatingActionButton(
        heroTag: "ok-tag-add",
        child: Text(
          "OK",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: SailyBlue,
        elevation: 10,
        onPressed: () {
          Navigator.of(context).pop();  
  }));
  
  // Create AlertDialog  
  AlertDialog alert = AlertDialog(  
    title: Text("Cannot add User"),  
    content: Text("User already Registered"),  
    actions: [  
      okButton,  
    ],  
  );  
  
  // show the dialog  
  showDialog(  
    context: context,  
    builder: (BuildContext context) {  
      return alert;  
    },  
  );  
}  

  // Different password 
  showAlertDialog(BuildContext context) {  
  // Create button  
  Widget okButton = SizedBox(
    width: gCtxW() * 0.9,
    child: FloatingActionButton(
        heroTag: "ok-tag",
        child: Text(
          "OK",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: SailyBlue,
        elevation: 10,
        onPressed: () {
          Navigator.of(context).pop();  
  }));
  
  // Create AlertDialog  
  AlertDialog alert = AlertDialog(  
    title: Text("Password Not matching"),  
    content: Text("Please check your password"),  
    actions: [  
      okButton,  
    ],  
  );  
  
  // show the dialog  
  showDialog(  
    context: context,  
    builder: (BuildContext context) {  
      return alert;  
    },  
  );  
}  
}
