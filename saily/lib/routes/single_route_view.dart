import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:saily/datatypes/electricmotor_info.dart';
import 'package:saily/datatypes/highpowerbattery_info.dart';
import 'package:saily/datatypes/nmea2000_info.dart';
import 'package:saily/datatypes/route_info.dart';
import 'package:saily/routes/import_view.dart';
import 'package:saily/routes/route_widget.dart';
import 'package:saily/settings/settings_controller.dart';
import 'package:latlong2/latlong.dart';
import 'package:saily/boats/boat_widget.dart';
import 'package:saily/utils/saily_utils.dart';
import 'package:saily/utils/saily_colors.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

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
                    child: Stack(
                      children: [
                        FlutterMap(
                            options: MapOptions(
                              interactionOptions: const InteractionOptions(
                                flags: InteractiveFlag.pinchZoom | InteractiveFlag.all,
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
                            ]),
                        
                        Positioned(child: FloatingActionButton(mini: true, 
                          child: Icon(Icons.info, color: SailyWhite,),
                          elevation: 0,
                          backgroundColor: SailyBlue,
                          onPressed: (){

                        }), top: 3, left: 3,)
                      ],
                    )),
              )),
              SizedBox(
                  height: ctxH(context) / 2.5,
                  child: Container(
                    margin: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    // Dispaly the preview map with the route
                    child: 
                    Card(
                      color: SailyWhite,
                      elevation: 10,
                      child: SfCartesianChart(
                        title: ChartTitle(text: 'Data Chart'),
                        legend: Legend(isVisible: true),
                        series: [
                          LineSeries<VTGInfo, num>(
                            enableTooltip: false,
                            name: "SOG [Km/h]",
                            dataSource: route.vtgInfo,
                            xValueMapper: (VTGInfo v, __) => __,
                            yValueMapper: (VTGInfo v, __) => v.SOG,
                            width: 2,
                            color: SailyBlue,
                            markerSettings: MarkerSettings(
                                isVisible: true,
                                height: 4,
                                width: 4,
                                shape: DataMarkerType.circle,
                                borderWidth: 3,
                                borderColor: SailyBlue),
                            dataLabelSettings: DataLabelSettings(
                                //  isVisible: true,
                                color: SailyBlue,
                                labelAlignment: ChartDataLabelAlignment.auto)),
                          LineSeries<HighpowerbatteryInfo, num>(
                            enableTooltip: false,
                            name: "SOC [%]",
                            dataSource: route.hpibInfo,
                            xValueMapper: (v, __) => __,
                            yValueMapper: (v, __) => v.SOC,
                            width: 2,
                            color: SailySuperGreen,
                            markerSettings: MarkerSettings(
                                isVisible: true,
                                height: 4,
                                width: 4,
                                shape: DataMarkerType.circle,
                                borderWidth: 3,
                                borderColor: SailySuperGreen),
                            dataLabelSettings: DataLabelSettings(
                                color: SailySuperGreen,
                                labelAlignment: ChartDataLabelAlignment.auto)),

                          LineSeries<ElectricmotorInfo, num>(
                            enableTooltip: false,
                            name: "M. Current. [A]",
                            dataSource: route.emInfo,
                            xValueMapper: (v, __) => __,
                            yValueMapper: (v, __) => v.motorCurrent,
                            width: 2,
                            color: SailySuperRed,
                            markerSettings: MarkerSettings(
                                isVisible: true,
                                height: 4,
                                width: 4,
                                shape: DataMarkerType.circle,
                                borderWidth: 3,
                                borderColor: SailySuperRed),
                            ),

                          LineSeries<ElectricmotorInfo, num>(
                            enableTooltip: false,
                            name: "M. RPM [num/100]",
                            dataSource: route.emInfo,
                            xValueMapper: (v, __) => __,
                            yValueMapper: (v, __) => v.motorRPM / 100,
                            width: 2,
                            color: SailyGrey,
                            markerSettings: MarkerSettings(
                                isVisible: true,
                                height: 4,
                                width: 4,
                                shape: DataMarkerType.circle,
                                borderWidth: 3,
                                borderColor: SailyGrey),
                            )
                        ]
                      )
                    )
                    ),
              )),
            ],
          ),
        ));
  }
}
