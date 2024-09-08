import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:saily/datatypes/route_info.dart';
import 'package:saily/main.dart';
import 'package:saily/utils/saily_colors.dart';
import 'package:saily/utils/saily_utils.dart';
import 'package:share/share.dart';

///
/// This widget allows to view a single route and select it
///
class ImportWidget extends StatelessWidget {
  ImportWidget({required this.info, required this.onImport});
  RouteInfo info;

  // Function used for passing a onDelete callback
  void Function() onImport = () {};

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
                                mapController: MapController(
                                ),
                                children: [
                                  // actual map
                                  TileLayer(
                                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                    userAgentPackageName: 'com.example.huracan_marine',
                                    tileProvider: CancellableNetworkTileProvider(),
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
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                
                                Row(children: [Text(info.name, style: TextStyle(fontWeight: FontWeight.bold),)]),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: gCtxW() * 0.3,
                                        child: FloatingActionButton(
                                          heroTag: "import_route_" + info.id,
                                          elevation: 2,
                                          backgroundColor: SailyBlue,
                                          onPressed: () {
                                            Navigator.pop(context);
                                            onImport();
                                          },
                                          child: Text("Import", style: TextStyle(color: Colors.white),)
                                        ),
                                      ),
                                    ])
                              ],
                            ))),
                  ),
                ])));
  }
}
