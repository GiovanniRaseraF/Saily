import 'package:flutter/material.dart';
import 'package:saily/datatypes/boat_info.dart';
import 'package:saily/utils/saily_colors.dart';
import 'package:saily/utils/saily_utils.dart';

class UserController {
  // Dialog creator
  static void dialogCreator(
      BuildContext context,
      String scannedId,
      void Function(String) onChangedNameTextField,
      void Function() onPressedNewBoat,
      void Function() onPressedDiscard) {
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
                Text('New Boat',style: TextStyle(fontSize: 20),),
                SizedBox(
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Name',
                    ),
                    onChanged: onChangedNameTextField,
                  ),
                ),
                Divider(color: Colors.transparent,),
                Text("ID: ${scannedId}", style: TextStyle(fontSize: 20),),
                // button to add the new boat 
                SizedBox(
                    width: gCtxW() * 0.9,
                    child: FloatingActionButton(
                      heroTag: "add_new_boat",
                      child: Text("Save",style: TextStyle(color: Colors.white),),
                      backgroundColor: SailyBlue,
                      elevation: 10,
                      onPressed: onPressedNewBoat,
                    )),
                Divider(color: Colors.transparent,),
                Divider(color: Colors.transparent,),

                // Dont andd the boat 
                TextButton(
                  onPressed: onPressedDiscard,
                  child: const Text('Discard'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}