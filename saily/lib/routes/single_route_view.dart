import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:saily/datatypes/route_info.dart';
import 'package:saily/routes/import_view.dart';
import 'package:saily/routes/route_widget.dart';
import 'package:saily/settings/settings_controller.dart';
import 'package:latlong2/latlong.dart';
import 'package:saily/boats/boat_widget.dart';
import 'package:saily/utils/saily_utils.dart';
import 'package:saily/utils/saily_colors.dart';

class SingleRouteView extends StatefulWidget {
  SingleRouteView(
      {super.key, required this.settingsController, required this.route});

  final String title = "Route";
  RouteInfo route;
  SettingsController settingsController;

  @override
  State<SingleRouteView> createState() => _SingleRouteViewState(
      settingsController: settingsController, route: route);
}

class _SingleRouteViewState extends State<SingleRouteView> {
  _SingleRouteViewState(
      {required this.settingsController, required this.route});

  RouteInfo route;
  SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    // Create the view with the sorted routes
    return Scaffold(
        appBar: AppBar(
          title:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(route.name),
          ]),
          backgroundColor: Colors.white,
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                  height: ctxH(context) /2.5,
                  child: Container(
                    margin: EdgeInsets.all(10),
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    // Dispaly the preview map with the route
                    child: FlutterMap(
                        options: MapOptions(
                          interactionOptions: const InteractionOptions(
                            flags: InteractiveFlag.pinchZoom,
                          ),
                          initialCenter: (route.positions.length == 0) ? LatLng(0,0) : route.positions[0],
                          initialZoom: 12,
                        ),
                        mapController: MapController(),
                        children: [
                          // actual map
                          TileLayer(
                            urlTemplate:
                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName: 'com.example.huracan_marine',
                            tileProvider: CancellableNetworkTileProvider(),
                          ),
                          PolylineLayer(simplificationTolerance: 0, polylines: [
                            Polyline(
                              points: route.positions,
                              strokeWidth: 3,
                              color: SailyBlue,
                            ),
                          ])
                        ])),
              )),
              SizedBox(
                  height: ctxH(context) /2.5,
                  child: Container(
                    margin: EdgeInsets.all(10),
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    // Dispaly the preview map with the route
                    child: Text("data")),
              )),
            ],
          ),
        ));
  }
}
