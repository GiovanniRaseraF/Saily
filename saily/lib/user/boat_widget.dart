import 'package:flutter/material.dart';
import 'package:saily/utils/saily_colors.dart';
import 'package:saily/utils/saily_utils.dart';

class BoatWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 120,
        width: gCtxW() * 0.9,
        child: Card(
            elevation: 10,
            color: Colors.white,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      color: Colors.white,
                      height: 120,
                      width: gCtxW() * 0.4,
                      child: Container(
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          child: Image.asset(
                            "images/boat.jpeg",
                            fit: BoxFit.fill,
                          ),
                        ),
                      )),
                  SizedBox(
                    height: 120,
                    width: gCtxW() * 0.45,
                    child: SizedBox(
                        height: 200,
                        width: gCtxW() * 0.5,
                        child: Card(
                            color: Colors.white,
                            elevation: 0,
                            child: Column(
                              children: [
                                Row(children: [Text("Albachiara")]),
                                Row(children: [Text("OnLine")]),
                                Divider(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                  FloatingActionButton(
                                    heroTag: "select_boat_",
                                    elevation: 2,
                                    mini: true,
                                    backgroundColor: Colors.white,
                                    onPressed: () {
                                      print("Select boat");
                                    },
                                    child: Icon(
                                      Icons.visibility,
                                      color: SailyBlue,
                                    ),
                                  ),
                                  FloatingActionButton(
                                    heroTag: "delete_boat_",
                                    elevation: 2,
                                    mini: true,
                                    backgroundColor: Colors.white,
                                    onPressed: () {
                                      print("Delete boat");
                                    },
                                    child: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                  ),
                                ])
                              ],
                            ))),
                  ),
                ])));
  }
}
