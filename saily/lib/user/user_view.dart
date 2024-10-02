// Actual app
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:saily/addnewboat/addnewboat_view.dart';
import 'package:saily/datatypes/boat_info.dart';
import 'package:saily/datatypes/user_info.dart';
import 'package:saily/settings/settings_controller.dart';
import 'package:saily/user/boat_widget.dart';
import 'package:saily/user/user_controller.dart';
import 'package:saily/user/user_widget.dart';
import 'package:saily/utils/saily_utils.dart';
import 'package:saily/utils/saily_colors.dart';
import 'package:saily/utils/utils.dart';
import 'package:saily/widgets/fract_box.dart';

class UserView extends StatefulWidget {
  UserView(
      {super.key, required this.settingsController, required this.onLogout});

  final String title = "user";
  SettingsController settingsController;

  void Function() onLogout;

  @override
  State<UserView> createState() => _UserViewState(
      settingsController: settingsController, onLogout: onLogout);
}

class _UserViewState extends State<UserView> {
  _UserViewState({required this.settingsController, required this.onLogout});

  SettingsController settingsController;

  void Function() onLogout;

  @override
  Widget build(BuildContext context) {
    UserInfo? currentUser = settingsController.getLoggedUser();

    return OrientationBuilder(builder: (c, or) {
      var w = scaleW(c, 1);
      var h = scaleH(c, 0.45);

      if (or == Orientation.portrait || true) {
        return Scaffold(
        appBar: AppBar(
          title: Text("User"),
          backgroundColor: Colors.white,
        ),
        backgroundColor: Colors.white,
          body: Center(
            child: Column(
              children: [
                // Card(
                //   elevation: 10,
                //   child: TravelDestinationContent(destination: destinations[0])),
              ],
            ),
          )
        );
      }else{
        return Scaffold(
          body: Row(
            children: [],
          ));
      }});

    return Scaffold(
        appBar: AppBar(
          title: Text("User"),
          backgroundColor: Colors.white,
        ),
        backgroundColor: Colors.white,
        body: 
        // Column(
        //   mainAxisAlignment: MainAxisAlignment.start,
        //   children: [
            // FractionallySizedBox(
            //     alignment: Alignment.topCenter,
            //     child: Center(
            //       child: Column(
            //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //         children: [
            //           Text("${currentUser!.username}"),
            //           Text("${currentUser!.email}"),

            //           FittedBox(
            //               child: SizedBox(
            //                 width: 200,
            //                 child: FloatingActionButton(
            //                     heroTag: "logout",
            //                     child: Text(
            //                       "Logout",
            //                       style: TextStyle(color: Colors.white),
            //                     ),
            //                     backgroundColor: SailyBlue,
            //                     elevation: 10,
            //                     onPressed: () {
            //                       settingsController.logout();
            //                       Navigator.pop(context);
            //                       onLogout();
            //                       print("Log out from account");
            //                     }),
            //               ))
            //         ],
            //       ),
            //     )),
            // Divider(),
            // SizedBox( child: Text("Boats"),),
            Column(
              children: [
                SizedBox.expand(
                  child: FractionallySizedBox(
                    widthFactor: 1,
                    heightFactor: 0.2,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.red,
                          width: 4,
                        ),
                      ),
                    ),
                  ),
                ),
                // SizedBox.expand(
                //   child: FractionallySizedBox(
                //     widthFactor: 1,
                //     heightFactor: 0.6,
                //     child: DecoratedBox(
                //       decoration: BoxDecoration(
                //         border: Border.all(
                //           color: Colors.blue,
                //           width: 4,
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
              ]
            ),
            // FittedBox(
            //   fit: BoxFit.contain,
            //   child:SizedBox(
            //     child: SizedBox(
            //       child: Center(
            //         child: SingleChildScrollView(
            //           child: Column(
            //             children : currentUser!.boats.map((b){
            //               return BoatWidget(info: b, settingsController: settingsController, onDelete: (){setState(() {});},);
            //             }).toList()
            //           ),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            
        //   ],
        // ),
        floatingActionButton: SizedBox(
                child: FloatingActionButton(
                    heroTag: "add_new_boat",
                    child: Icon(Icons.add, color: SailyAlmostWhite,),
                    backgroundColor: SailyBlue,
                    elevation: 10,
                    onPressed: () {
                      String name = "DefaultBoat";
                      print("Add New Boat");
                      Navigator.push(context, MaterialPageRoute(builder: (c){
                        return TakePictureScreen(
                          settingsController: settingsController,
                          onQRCodeTaken: (scannedId){
                            UserController.dialogCreator(context, scannedId, 
                            (v){name = v;}, 
                            (){
                              BoatInfo newboat = BoatInfo(name: name, id: "0x" + name);
                              settingsController.addNewBoat(newboat);
                              Navigator.pop(context);
                              setState(() {});
                              },
                            (){Navigator.pop(context);});
                          },
                          );
                      }));
                    })),
        );
  }
}
