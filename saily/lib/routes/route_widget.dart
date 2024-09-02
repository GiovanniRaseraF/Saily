import 'package:flutter/material.dart';
import 'package:saily/utils/saily_colors.dart';
import 'package:saily/utils/saily_utils.dart';

class RouteWidget extends StatelessWidget {
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
                      color: Colors.white,
                      height: 150,
                      width: gCtxW() * 0.4,
                      child: Container(
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          child: Image.asset(
                            "images/map.png",
                            fit: BoxFit.fill,
                          ),
                        ),
                      )),
                  SizedBox(
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
                                Row(children: [Text("Giro generico")]),
                                Row(children: [Text("from: 2024/09/10-12:30")]),
                                Row(children: [Text("to: 2024/09/10-7:00")]),
                                Divider(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                  FloatingActionButton(
                                    heroTag: "view_route_",
                                    elevation: 2,
                                    mini: true,
                                    backgroundColor: Colors.white,
                                    onPressed: () {
                                      print("View Route");
                                    },
                                    child: Icon(
                                      Icons.visibility,
                                      color: SailyBlue,
                                    ),
                                  ),
                                  FloatingActionButton(
                                    heroTag: "share_route_",
                                    elevation: 2,
                                    mini: true,
                                    backgroundColor: Colors.white,
                                    onPressed: () {
                                      print("Sharare Route");
                                    },
                                    child: Icon(
                                      Icons.share,
                                      color: SailyBlue,
                                    ),
                                  ),
                                  FloatingActionButton(
                                    heroTag: "delete_route_",
                                    elevation: 2,
                                    mini: true,
                                    backgroundColor: Colors.white,
                                    onPressed: () {
                                      print("Delete route");
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
