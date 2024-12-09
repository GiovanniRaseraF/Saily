import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:latlong2/latlong.dart';
import 'package:saily/datatypes/route_info.dart';
import 'package:saily/routes/import_widget.dart';
import 'package:saily/routes/route_widget.dart';
import 'package:saily/settings/settings_controller.dart';
import 'package:saily/boats/boat_widget.dart';
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
    RouteInfo(name: "Da Giovanni", positions: [
      LatLng( 43.52120256331884,  7.056244213486337),
      LatLng(43.52120256331884,  7.056972511028611),
      LatLng( 43.52120256331884,  7.057549079916243),
      LatLng( 43.521158554734676,7.058216685996662),
      LatLng( 43.52100452443738, 7.058914637807968),
      LatLng( 43.52091650694805, 7.059430515233745),
      LatLng( 43.52087249815524, 7.060007084121378),
      LatLng( 43.52078448047333, 7.060735381663653),
      LatLng( 43.52071846712764, 7.061888519438921),
      LatLng( 43.52071846712764, 7.062586471250265),
      LatLng( 43.52065245370971, 7.063436151716252),
      LatLng( 43.52043240846161, 7.06395202914199),
      LatLng( 43.520168353104566, 7.064528598029623),
      LatLng( 43.51986028706073,  7.064953438262616),
      LatLng( 43.51972825827471,  7.06528724130282),
      ], from: "", to: "1", hpibInfo: [], emInfo: [], vtgInfo: []),
    RouteInfo(name: "Da Federico", positions: [LatLng(45.134176, 13.724200)], from: "", to: "2", hpibInfo: [], emInfo: [], vtgInfo: []),
  ];

  @override
  Widget build(BuildContext context) {
    // Create the view with the sorted routes
    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Import Route"), 
              ]),
          backgroundColor: Colors.white,
        ),
        backgroundColor: Colors.white,
        body: Center(
          child: ListView(
            children: routes.map((r){
              RouteInfo newR = RouteInfo(name: r.name, positions: r.positions, from: DateTime.now().toString(), to: DateTime.now().toString(), hpibInfo: [], emInfo: [], vtgInfo: []);
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
