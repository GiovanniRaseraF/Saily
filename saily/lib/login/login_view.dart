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
  _LoginViewState({required this.settingsController, required this.onLogin}) {
    homePage = MyHomePage(
        title: "Home Page",
        settingsController: this.settingsController,
        onLogout: () {
          setState(() {});
        });
  }
  late Widget homePage;
  SettingsController settingsController;

  void Function() onLogin;

  @override
  Widget build(BuildContext context) {
    // check login
    if (settingsController.canUserLogin(
        settingsController.getUsername(), settingsController.getPassword())) {
      return homePage;
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      color: SailyBlue,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          margin: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _header(context),
              _inputField(context),
              _signup(context),
            ],
          ),
        ),
      ),
    );
  }

  _header(context) {
    return const Column(
      children: [
        Text(
          "Saily",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        Text("Welcome back Sailyer :)"),
      ],
    );
  }

  _inputField(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          decoration: InputDecoration(
              hintText: "Username",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: SailyBlue)),
              fillColor: Colors.white,
              filled: true,
              prefixIcon: const Icon(Icons.person)),
          onChanged: (value) {
            settingsController.setUsername(value);
          },
        ),
        SizedBox(height: 10),
        TextField(
          decoration: InputDecoration(
            hintText: "Password",
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: SailyBlue)),
            fillColor: Colors.white,
            filled: true,
            prefixIcon: Icon(Icons.password),
          ),
          obscureText: true,
          onChanged: (value) {
            settingsController.setPassword(value);
          },
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            UserInfo? user = settingsController.getUser(
                settingsController.getUsername(),
                settingsController.getPassword());
            if (user == null) {
              print(
                  "User ${settingsController.getUsername()}, ${settingsController.getPassword()} does not exist");
            } else {
              settingsController.login(settingsController.getUsername(),
                  settingsController.getPassword());
            }
            setState(() {});
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: SailyBlue,
          ),
          child: Text(
            "Login",
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        )
      ],
    );
  }

  _signup(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Want to be a Sailyer ? "),
        TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        RegisterView(settingsController: settingsController)),
              );
            },
            child: Text(
              "Register",
              style: TextStyle(color: SailyBlue),
            ))
      ],
    );
  }
}
