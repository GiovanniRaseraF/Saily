import 'package:flutter/material.dart';
import 'package:saily/datatypes/boat_info.dart';
import 'package:saily/settings/settings_controller.dart';
import 'package:saily/utils/saily_colors.dart';
import 'package:saily/utils/saily_utils.dart';

class BoatWidget extends StatelessWidget {
  BoatWidget({required this.info, required this.settingsController, required this.onDelete, required this.onSelect});

  BoatInfo info;
  SettingsController settingsController;
  void Function(BoatInfo) onDelete = (BoatInfo boat){
    print("Your want to delete: $boat");
  };
  void Function(BoatInfo) onSelect = (BoatInfo boat){
    print("Your selected: $boat");
  };

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
                                FittedBox(child: Row(children: [Text(info.boat_name, style: TextStyle(fontWeight: FontWeight.bold),)])),
                                FittedBox(child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [Icon(Icons.online_prediction, color: SailyBlue,),Text("online", style: TextStyle(fontWeight: FontWeight.bold),)])),
                                FittedBox(child: Row(children: [Text("id: ${info.boat_id}")])),
                                Divider(),
                                FittedBox(
                                  child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        FloatingActionButton(
                                          heroTag: "view_boat_" + info.boat_id,
                                          elevation: 2,
                                          mini: true,
                                          backgroundColor: Colors.white,
                                          onPressed: () {
                                            print("Select Boat ${info.boat_id}");
                                            settingsController.setCurrentBoat(info);
                                            //Navigator.pop(context);
                                            onSelect(info);
                                          },
                                          child: Icon(
                                            Icons.visibility,
                                            color: SailyBlue,
                                          ),
                                        ),
                                        FloatingActionButton(
                                          heroTag: "delete_boat_" + info.boat_id,
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
                                                        Text('Delete: ${info.boat_name} ?', style: TextStyle(fontSize: 15)),
                                                        Divider( color: Colors.transparent),
                                                        Divider( color: Colors.transparent),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
                                                          children: [
                                                            // Confirm Delete
                                                            SizedBox(
                                                                width:  gCtxW() * 0.3,
                                                                child: FloatingActionButton(
                                                                  heroTag: "confirm_delete_boat_${info.boat_id}",
                                                                  child: Text("Yes",  style: TextStyle(color:Colors.white)),
                                                                  backgroundColor: Colors.red,
                                                                  elevation: 10,
                                                                  onPressed: () {
                                                                    print("Delete boat ${info.boat_name}");
                                                                    Navigator.pop(context);
                                                                    onDelete(info);
                                                            })),
                                                            // Decline Delete
                                                            SizedBox(
                                                                width: gCtxW() * 0.3,
                                                                child: FloatingActionButton(
                                                                heroTag: "decline_delete_boat_${info.boat_id}",
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
                                      ]),
                                )
                              ],
                            ))),
                  ),
                ])));
  }
}
