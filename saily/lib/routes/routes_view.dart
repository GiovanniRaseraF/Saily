import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:saily/routes/route_widget.dart';
import 'package:saily/settings/settings_controller.dart';
import 'package:saily/user/boat_widget.dart';
import 'package:saily/utils/saily_utils.dart';
import 'package:saily/utils/saily_colors.dart';

class RoutesView extends StatefulWidget {
  RoutesView({super.key, required this.settingsController});

  final String title = "routes";
  SettingsController settingsController;

  @override
  State<RoutesView> createState() =>
      _RoutesViewState(settingsController: settingsController);
}

class _RoutesViewState extends State<RoutesView> {
  _RoutesViewState({required this.settingsController});

  SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    var routes = settingsController.getRoutes();
    routes.sort((a, b) {
      return b.from.compareTo(a.from);
    });

    // Create the view with the sorted routes
    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Routes"), 
              FloatingActionButton(
                elevation: 0,
                backgroundColor: Colors.white,
                mini: true, onPressed: (){print("Import route");}, child: Icon(Icons.import_contacts, color: SailyBlue,),)]),
          backgroundColor: Colors.white,
        ),
        backgroundColor: Colors.white,
        body: Center(
          child: SingleChildScrollView(
              child: Column(
                  children: routes.map((e) {
            // map routes with the actual view
            return RouteWidget(
              info: e,
              onDelete: () {
                setState(() {});
              },
            );
          }).toList())),
        ));
  }
}
