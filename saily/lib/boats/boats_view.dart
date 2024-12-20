// Actual app
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:saily/addnewboat/addnewboat_view.dart';
import 'package:saily/boats/selected_boat_view.dart';
import 'package:saily/datatypes/boat_info.dart';
import 'package:saily/datatypes/user_info.dart';
import 'package:saily/main.dart';
import 'package:saily/server/server.dart';
import 'package:saily/settings/settings_controller.dart';
import 'package:saily/boats/boat_widget.dart';
import 'package:saily/user/user_controller.dart';
import 'package:saily/user/user_widget.dart';
import 'package:saily/utils/saily_utils.dart';
import 'package:saily/utils/saily_colors.dart';
import 'package:saily/utils/utils.dart';
import 'package:saily/widgets/fract_box.dart';

class BoatsView extends StatefulWidget {
  BoatsView({super.key, required this.settingsController, required this.server, required this.onSelect});

  final String title = "Boats";
  SettingsController settingsController;
  Server server;
  void Function(BoatInfo) onSelect = (BoatInfo boat){};

  @override
  State<BoatsView> createState() =>
      _BoatsViewState(settingsController: settingsController, server: server, onSelect: onSelect);
}

class _BoatsViewState extends State<BoatsView> {
  _BoatsViewState({required this.settingsController, required this.server, required this.onSelect}){
    server.boatsList(settingsController.username, settingsController.password).then((res){
        setState(() {
          // get the boats
          numOfBoats = res.length;
          boats = res;
        });
      });
  }

  SettingsController settingsController;
  Server server;
  int numOfBoats = 0;
  List<BoatInfo> boats = [];
  void Function(BoatInfo) onSelect = (BoatInfo boat){};

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (c, or) {
      var w = scaleW(c, 1);
      var h = scaleH(c, 0.45);

      if (or == Orientation.portrait || true) {
        return Scaffold(
            appBar: AppBar(
              title: Text("Boats"),
              backgroundColor: Colors.white,
            ),
            backgroundColor: Colors.white,
            body: numOfBoats == 0
                ? Center(child: Text("No boats, use + to add one :)"))
                :
                // List of boats
                SizedBox(
                    child: Center(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.only(bottom: 100),
                        child: Column(
                          children: boats.map((b) {
                            if(b.boat_id == settingsController.currentBoat.boat_id){
                              return 
                                Card(
                                  color: SailyBlue,
                                  margin: EdgeInsets.all(8),
                                  child: SelectedBoatWidget(info: b, onStopFollowingBoat: (){
                                    setState(() {});
                                  }),
                                );
                            }else{
                              return BoatWidget(
                                info: b,
                                settingsController: settingsController,
                                onDelete: (toDelete) async {
                                  final deleted = await server.deleteBoat(toDelete);
                                  if(deleted){
                                    debugPrint("Deleted: $toDelete");
                                  }else{
                                    debugPrint("Cannot Deleted: $toDelete");
                                  }
                                  setState(() {});
                                },
                                onSelect: (info){
                                    onSelect(info);
                                    setState(() {
                                      
                                    });
                                  },
                              );
                            }
                        }).toList()),
                      ),
                    ),
                  ),
            floatingActionButton: SizedBox(
              child: FloatingActionButton(
                  heroTag: "add_new_boat",
                  child: Icon(
                    Icons.add,
                    color: SailyAlmostWhite,
                  ),
                  backgroundColor: SailyBlue,
                  elevation: 10,
                  onPressed: () {
                    String name = "DefaultBoat";
                    print("Add New Boat");
                    Navigator.push(context, MaterialPageRoute(builder: (c) {
                      return TakePictureScreen(
                        settingsController: settingsController,
                        onQRCodeTaken: (scannedId) async {
                          UserController.dialogCreator(
                            context, 
                            scannedId, 
                            (v) {
                              name = v;
                            }, 
                            () async {
                              BoatInfo newboat = BoatInfo(boat_name: name, boat_id: "0x" + scannedId);
                              await server.addNewBoat(newboat);

                              Navigator.pop(context);
                              setState(() {});
                          }, () {
                            Navigator.pop(context);
                          });
                        },
                      );
                    }));
                  }),
            ));
      } else {
        return Scaffold(
            body: Row(
          children: [],
        ));
      }
    });
  }
}
