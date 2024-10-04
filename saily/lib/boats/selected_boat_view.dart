import 'package:flutter/material.dart';
import 'package:saily/datatypes/boat_info.dart';
import 'package:saily/settings/settings_controller.dart';
import 'package:saily/utils/saily_colors.dart';
import 'package:saily/utils/saily_utils.dart';

class SelectedBoatWidget extends StatelessWidget {
  SelectedBoatWidget({required this.info});

  BoatInfo info;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        child: Card(
            elevation: 0,
            color: Colors.white,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      margin: EdgeInsets.all(10),
                      color: Colors.white,
                      child: Container(
                        child: ClipRRect(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            child: Image.asset(
                              "images/boat.jpeg",
                              fit: BoxFit.fill,
                            )),
                      )),
                  // Dispay the rest of the info
                  Card(
                    color: Colors.white,
                    elevation: 0,
                    child: Column(
                      children: [
                        Row(children: [
                          Text(
                            info.name,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
                        ]),
                        Row(children: [
                          Icon(
                            Icons.online_prediction,
                            color: SailyBlue,
                          ),
                          Text(
                            "online",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
                        ]),
                        Row(children: [Text("id: ${info.id}")]),
                      ],
                    ),
                  ),
                ])));
  }
}
