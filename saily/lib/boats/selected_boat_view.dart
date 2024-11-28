import 'package:flutter/material.dart';
import 'package:saily/datatypes/boat_info.dart';
import 'package:saily/main.dart';
import 'package:saily/settings/settings_controller.dart';
import 'package:saily/utils/saily_colors.dart';
import 'package:saily/utils/saily_utils.dart';

class SelectedBoatWidget extends StatelessWidget {
  SelectedBoatWidget({required this.info, required this.onStopFollowingBoat});

  BoatInfo info;
  void Function() onStopFollowingBoat;

  @override
  Widget build(BuildContext context) {
    if(info.boat_name == "" || info.boat_id == ""){
      return Text("Please select a boat in the Boats Menu ;)");
    }
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
                            child: Image.asset(
                              "images/boat.jpeg",
                              fit: BoxFit.fill,
                            )),
                      )),
                  // Dispay the rest of the info
                  Center(
                    child: SizedBox(
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
                                  FittedBox(
                                    child: Row(children: [
                                    Text(info.boat_name, style: TextStyle(fontWeight: FontWeight.bold),)
                                  ])),
                                  FittedBox(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Icon(Icons.online_prediction, color: SailyBlue,),
                                        Text("online", style: TextStyle(fontWeight: FontWeight.bold),)
                                      ])),
                                  FittedBox(child: Row(children: [Text("id: ${info.boat_id}")])),

                                Divider(),
                                FittedBox(
                                  child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        FloatingActionButton(
                                          heroTag: "stop_seeing_selected_boat" + info.boat_id,
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
                                                        Text('Stop following: ${info.boat_name} ?', style: TextStyle(fontSize: 15)),
                                                        Divider( color: Colors.transparent),
                                                        Divider( color: Colors.transparent),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
                                                          children: [
                                                            // Confirm Delete
                                                            SizedBox(
                                                                width:  gCtxW() * 0.3,
                                                                child: FloatingActionButton(
                                                                  heroTag: "confirm_stop_following_boat_${info.boat_id}",
                                                                  child: Text("Yes",  style: TextStyle(color:Colors.white)),
                                                                  backgroundColor: Colors.red,
                                                                  elevation: 10,
                                                                  onPressed: () {
                                                                    print("Stop Following boat ${info.boat_name}");
                                                                    Navigator.pop(context);
                                                                    settingsController.setCurrentBoat(BoatInfo(boat_name: "", boat_id: ""));
                                                                    onStopFollowingBoat();
                                                            })),
                                                            // Decline Delete
                                                            SizedBox(
                                                                width: gCtxW() * 0.3,
                                                                child: FloatingActionButton(
                                                                heroTag: "decline_stop_following_boat_${info.boat_id}",
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
                                          child: Icon(Icons.visibility_off, color: SailySuperRed),
                                        ),
                                      ]),
                                )
                                ],
                              ))),
                    ),
                  ),
                ])));
  }
}
