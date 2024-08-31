/*
author: Giovanni Rasera
*/


import 'package:flutter/material.dart';

// class SpeedGauge extends StatefulWidget {
//   SpeedGauge({
//     required this.wscale, 
//     required this.hscale, 
//     required this.textscale, 
//     required this.settingsController,
//     required this.small,
//   });

//   bool small;

//   double wscale;
//   double hscale;
//   double textscale;

//   SettingsController settingsController;

//   @override
//   State<SpeedGauge> createState() => 
//     _SpeedGaugeState(
//       wscale: wscale, 
//       hscale: hscale, 
//       textscale: textscale, 
//       settingsController: settingsController,
//       small: small,
//     );
// }

// class _SpeedGaugeState extends State<SpeedGauge>{
//   _SpeedGaugeState({
//     required this.wscale, 
//     required this.hscale, 
//     required this.textscale, 
//     required this.settingsController,
//     required this.small,
//   });

//   bool small;

//   double wscale;
//   double hscale;
//   double textscale;
  
//   SettingsController settingsController;
//   late SpeedData speedDataStream;
//   late DriveMotorData driveMotorDataStream;
//   late Styles appStyle;

//   @override
//   void dispose(){
//     super.dispose();
//   }

//   @override
//   void initState(){
//     super.initState();
    
//     updateSpeedDataStream(settingsController.speedStream);
//     updateDriveMotorDataStream(settingsController.driveMotorStream);
//   }

//   void updateSpeedDataStream(SpeedData newsd){
//     if(mounted){
//       speedDataStream = newsd;
//       // speed kn
//     }
//   }
  
//   void updateDriveMotorDataStream(DriveMotorData newdmd){
//     if(mounted){
//       driveMotorDataStream = newdmd;
//       // rpms and other values
//     }
//   }

//   void updateAppStyle(Styles newas){
//     if(mounted){
//       appStyle = newas;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ListenableBuilder(listenable: settingsController, builder: (context, child) {
//       updateSpeedDataStream(settingsController.speedStream);
//       updateDriveMotorDataStream(settingsController.driveMotorStream);

//       updateAppStyle(getAppStyle(settingsController));

//       if(small){
//         return _getTextGauge(context);
//       }else{
//         return _getRadialGauge(context);
//       } 
//     },);
    
//   }

//   Widget _getTextGauge(BuildContext c){
//     return StreamBuilder(stream: speedDataStream.streamOut.stream, 
//       builder: (c, s){
//         final sog = speedDataStream.csg_SOG.toStringAsFixed(1);

//         return Row(
//           children: [
//             Icon(
//               Icons.speed,
//               color: Colors.blue,
//             ),
//             Text("    "),
//             Text('$sog kn',
//               style: TextStyle(fontSize: 20*textscale, fontWeight: FontWeight.bold))
//           ]);
//       }
//     );
    
//   }

//   // graphics
//   Widget _getRadialGauge(BuildContext c) {
//     return 
//        Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           // RPM
//           StreamBuilder(
//             stream: driveMotorDataStream.streamOut.stream,
//             builder: (context, s) {
//               final rpm_value = driveMotorDataStream.drv_motorSpeed;
//               final rpm = rpm_value.toStringAsFixed(0);

//               return CircularGaugeWidget(wscale: wscale, hscale: hscale, textscale: textscale, 
//                 headText: "RPM", 
//                 textBeforeValue: "", 
//                 value: rpm_value, 
//                 valueToDisplay: rpm,
//                 textAfterValue: "", 
//                 color: appStyle.primary_2_color, 
//                 startAngle: 180, 
//                 endAngle: 0, 
//                 minimum: 0, 
//                 maximum: 5000,
//                 appStyle: appStyle, 
//               );
//             }
//           ),

//           // speed
//           StreamBuilder(
//             stream: speedDataStream.streamOut.stream,
//             builder: (context, s) {
//               final speed_value = speedDataStream.csg_SOG;
//               final sog = speed_value.toStringAsFixed(1);

//               return CircularGaugeWidget(wscale: wscale, hscale: hscale, textscale: textscale, 
//                 headText: "Speed", 
//                 textBeforeValue: "", 
//                 value: speed_value, 
//                 valueToDisplay: sog,
//                 textAfterValue: " kn", 
//                 color: appStyle.secondary_color, 
//                 startAngle: 180, 
//                 endAngle: 0, 
//                 minimum: 0, 
//                 maximum: 50,
//                 appStyle: appStyle, 
//               );
//             }
//           ),

//           // temps
//           StreamBuilder(
//             stream: driveMotorDataStream.streamOut.stream,
//             builder: (context, c) {
//               final motor_temp_value = driveMotorDataStream.drv_motorTemperature;
//               final temp = motor_temp_value.toStringAsFixed(0);

//               return CircularGaugeWidget(wscale: wscale, hscale: hscale, textscale: textscale, 
//                 headText: "Temp", 
//                 textBeforeValue: "", 
//                 value: motor_temp_value, 
//                 valueToDisplay: temp,
//                 textAfterValue: " C°", 
//                 color: Colors.red, 
//                 startAngle: 180, 
//                 endAngle: 0, 
//                 minimum: 0, 
//                 maximum: 150,
//                 appStyle: appStyle, 
//               );
//             }
//           ),
//         ],
//       );
//   } 
// }
