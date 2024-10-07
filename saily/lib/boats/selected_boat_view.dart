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
        height: 150,
        width: gCtxW() * 0.9,
        child: Card(
            elevation: 10,
            color: Colors.white,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      margin: EdgeInsets.all(10),
                      color: Colors.white,
                      height: 150,
                      width: gCtxW() * 0.35,
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
                  Center(
                    child: SizedBox(
                      height: 150,
                      width: gCtxW() * 0.45,
                      child: SizedBox(
                          height: 200,
                          width: gCtxW() * 0.5,
                          child: Card(
                              color: Colors.white,
                              elevation: 0,
                              child: Column(
                                children: [
                                  FittedBox(
                                      child: Row(children: [
                                    Text(
                                      info.name,
                                      style:
                                          TextStyle(fontWeight: FontWeight.bold),
                                    )
                                  ])),
                                  FittedBox(
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                        Icon(
                                          Icons.online_prediction,
                                          color: SailyBlue,
                                        ),
                                        Text(
                                          "online",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )
                                      ])),
                                  FittedBox(
                                      child: Row(
                                          children: [Text("id: ${info.id}")])),
                                ],
                              ))),
                    ),
                  ),
                ])));
  }
}
