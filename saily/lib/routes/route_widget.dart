import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:saily/datatypes/route_info.dart';
import 'package:saily/main.dart';
import 'package:saily/utils/saily_colors.dart';
import 'package:saily/utils/saily_utils.dart';

class RouteWidget extends StatelessWidget {
  RouteWidget({required this.info});
  RouteInfo info;

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
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            child: FlutterMap(
                                options: MapOptions(
                                  interactionOptions: const InteractionOptions(
                                    flags: InteractiveFlag.pinchZoom,
                                  ),
                                  initialCenter: info.positions[0],
                                  initialZoom: 15,
                                ),
                                children: [
                                  // actual map
                                  TileLayer(
                                    urlTemplate:
                                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                    userAgentPackageName:
                                        'com.example.huracan_marine',
                                  ),
                                  PolylineLayer(
                                      simplificationTolerance: 0,
                                      polylines: [
                                        Polyline(
                                          points: info.positions,
                                          strokeWidth: 3,
                                          color: SailyBlue,
                                        ),
                                      ])
                                ])),
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
                                Row(children: [Text(info.name)]),
                                Row(children: [Text("date: ${info.from.split(" ")[0]}")]),
                                Row(children: [Text("time: ${info.from.split(" ")[1].split(".")[0]}")]),
                                Divider(),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      FloatingActionButton(
                                        heroTag: "view_route_",
                                        elevation: 2,
                                        mini: true,
                                        backgroundColor: Colors.white,
                                        onPressed: () {
                                          settingsController
                                              .setActiveRoute(info);
                                          Navigator.pop(context);
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
