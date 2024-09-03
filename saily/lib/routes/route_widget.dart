import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:saily/datatypes/route_info.dart';
import 'package:saily/main.dart';
import 'package:saily/utils/saily_colors.dart';
import 'package:saily/utils/saily_utils.dart';

///
/// This widget allows to view a single route and select it
///
class RouteWidget extends StatelessWidget {
  RouteWidget({required this.info, required this.onDelete});
  RouteInfo info;

  void Function() onDelete = () {};

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
                            // Dispaly the preview map with the route
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

                  // Dispay the rest of the info
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
                                Row(children: [
                                  Text("date: ${info.from.split(" ")[0]}")
                                ]),
                                Row(children: [
                                  Text(
                                      "time: ${info.from.split(" ")[1].split(".")[0]}")
                                ]),
                                Divider(),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      FloatingActionButton(
                                        heroTag: "view_route_" + info.id,
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
                                        heroTag: "share_route_" + info.id,
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
                                        heroTag: "delete_route_" + info.id,
                                        elevation: 2,
                                        mini: true,
                                        backgroundColor: Colors.white,
                                        onPressed: () {
                                          // create a dialog
                                          showDialog<String>(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                Dialog(
                                              child: Container(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Text(
                                                        'Delete: ${info.name} ?',
                                                        style: TextStyle(
                                                            fontSize: 15),
                                                      ),
                                                     Divider(color: Colors.transparent,),
                                                      Divider(
                                                        color:
                                                            Colors.transparent,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                        children: [

                                                          SizedBox(
                                                          width: gCtxW() * 0.3,
                                                          child:
                                                              FloatingActionButton(
                                                                  heroTag:
                                                                      "confirm_delete_${info.id}",
                                                                  child: Text(
                                                                    "Yes",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                  backgroundColor:
                                                                      Colors.red,
                                                                  elevation: 10,
                                                                  onPressed:
                                                                      () {
                                                                    print(
                                                                        "Delete route");
                                                                    settingsController
                                                                        .deleteRoute(
                                                                            info.id);
                                                                    onDelete();
                                                                    Navigator.pop(context);
                                                                  })),
                                                                  SizedBox(
                                                          width: gCtxW() * 0.3,
                                                          child:
                                                              FloatingActionButton(
                                                                  heroTag:
                                                                      "decline_delete_${info.id}",
                                                                  child: Text(
                                                                    "NO",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                  backgroundColor:
                                                                      SailyBlue,
                                                                  elevation: 10,
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(context);
                                                                  })),
                                                        ],
                                                      ),
                                                     Divider(color: Colors.transparent,) 
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
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
