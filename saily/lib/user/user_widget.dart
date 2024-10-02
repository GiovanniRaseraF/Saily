import 'package:flutter/material.dart';
import 'package:saily/datatypes/user_info.dart';
import 'package:saily/main.dart';
import 'package:saily/settings/settings_controller.dart';
import 'package:saily/utils/saily_colors.dart';
import 'package:saily/utils/saily_utils.dart';

class UserWidget extends StatelessWidget {
  UserWidget({super.key, required this.userInfo, required this.onLogout});

  final UserInfo userInfo;
  void Function() onLogout;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          height: 100,
          width: 100,
          child: Stack(
            children: [
              Positioned.fill(
                child: SizedBox(
                    width: 10,
                    height: 10,
                    child: Icon(Icons.person, size: 100, color: SailyBlue)),
              ),
            ],
          ),
        ),
        // Description and share/explore buttons.
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: DefaultTextStyle(
            softWrap: false,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(userInfo.username,
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(userInfo.email),
              ],
            ),
          ),
        ),

        // logout
        FittedBox(
            child: SizedBox(
          width: 100,
          child: FloatingActionButton(
              heroTag: "logout",
              child: Text(
                "Logout",
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: SailyBlue,
              elevation: 10,
              onPressed: onLogout),
        ))
      ],
    );
  }
}
