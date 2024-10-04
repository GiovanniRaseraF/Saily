import 'package:flutter/material.dart';
import 'package:saily/datatypes/boat_info.dart';
import 'package:saily/settings/settings_controller.dart';
import 'package:saily/utils/saily_colors.dart';
import 'package:saily/utils/saily_utils.dart';

class BoatWidget extends StatelessWidget {
  BoatWidget({required this.info, required this.settingsController, required this.onDelete});

  BoatInfo info;
  SettingsController settingsController;
  void Function() onDelete = (){};

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
                            borderRadius:BorderRadius.all(Radius.circular(10.0)),
                            child: Image.asset("images/boat.jpeg", fit: BoxFit.fill,)),
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
                                Row(children: [Text(info.name, style: TextStyle(fontWeight: FontWeight.bold),)]),
                                Text("", style: TextStyle(fontWeight: FontWeight.bold),),
                                Row(children: [Text("id: ${info.id}")]),
                                Divider(),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      FloatingActionButton(
                                        heroTag: "view_boat_" + info.id,
                                        elevation: 2,
                                        mini: true,
                                        backgroundColor: Colors.white,
                                        onPressed: () {
                                          print("Select Boat ${info.id}");
                                          Navigator.pop(context);
                                        },
                                        child: Icon(
                                          Icons.visibility,
                                          color: SailyBlue,
                                        ),
                                      ),
                                      FloatingActionButton(
                                        heroTag: "delete_boat_" + info.id,
                                        elevation: 2,
                                        mini: true,
                                        backgroundColor: Colors.white,
                                        onPressed: () {
                                          // create a dialog
                                          showDialog<String>(
                                            context: context,
                                            builder: (BuildContext context) => Dialog(
                                              child: Container(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: <Widget>[
                                                      Text('Delete: ${info.name} ?', style: TextStyle(fontSize: 15)),
                                                      Divider( color: Colors.transparent),
                                                      Divider( color: Colors.transparent),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
                                                        children: [
                                                          // Confirm Delete
                                                          SizedBox(
                                                              width:  gCtxW() * 0.3,
                                                              child: FloatingActionButton(
                                                                heroTag: "confirm_delete_boat_${info.id}",
                                                                child: Text("Yes",  style: TextStyle(color:Colors.white)),
                                                                backgroundColor: Colors.red,
                                                                elevation: 10,
                                                                onPressed: () {
                                                                  print("Delete boat ${info.name}");
                                                                  settingsController.deleteBoat(info.id);
                                                                  Navigator.pop(context);
                                                                  onDelete();
                                                          })),
                                                          // Decline Delete
                                                          SizedBox(
                                                              width: gCtxW() * 0.3,
                                                              child: FloatingActionButton(
                                                              heroTag: "decline_delete_boat_${info.id}",
                                                              child: Text("NO",  style: TextStyle( color:Colors.white )),
                                                              backgroundColor:  SailyBlue,
                                                              elevation: 10,
                                                              onPressed: () {
                                                                Navigator.pop(context);
                                                              }
                                                          )),
                                                        ],
                                                      ),
                                                      Divider( color: Colors.transparent),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                        child: Icon(Icons.delete, color: Colors.red),
                                      ),
                                    ])
                              ],
                            ))),
                  ),
                ])));
  }
}
