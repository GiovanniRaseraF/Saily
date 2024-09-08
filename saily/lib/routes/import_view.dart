import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:latlong2/latlong.dart';
import 'package:saily/datatypes/route_info.dart';
import 'package:saily/routes/import_widget.dart';
import 'package:saily/routes/route_widget.dart';
import 'package:saily/settings/settings_controller.dart';
import 'package:saily/user/boat_widget.dart';
import 'package:saily/utils/saily_utils.dart';
import 'package:saily/utils/saily_colors.dart';

class ImportView extends StatefulWidget {
  ImportView({super.key, required this.settingsController, required this.onDone});

  final String title = "import";
  SettingsController settingsController;
  void Function() onDone = (){};

  @override
  State<ImportView> createState() =>
      _ImportViewState(settingsController: settingsController);
}

class _ImportViewState extends State<ImportView> {
  _ImportViewState({required this.settingsController});

  SettingsController settingsController;
  List<RouteInfo> routes = [
    RouteInfo(name: "Da Giovanni", positions: [LatLng(45.199542, 13.589640)], from: "", to: "1"),
    RouteInfo(name: "Da Federico", positions: [LatLng(45.134176, 13.724200)], from: "", to: "2"),
  ];

  @override
  Widget build(BuildContext context) {
    // Create the view with the sorted routes
    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Routes"), 
              ]),
          backgroundColor: Colors.white,
        ),
        backgroundColor: Colors.white,
        body: Center(
          child: ListView(
            children: routes.map((r){
              RouteInfo newR = RouteInfo(name: r.name, positions: r.positions, from: DateTime.now().toString(), to: DateTime.now().toString());
              return ImportWidget(info: newR, 
              onImport: (){
                settingsController.importRoute(newR);
                widget.onDone(); 
              }
              ,);
            }).toList(),
          ),
        ));
  }
}
