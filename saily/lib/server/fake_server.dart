import 'dart:async';
import 'dart:math';

import 'package:dart_either/src/dart_either.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:saily/datatypes/actuator_info.dart';
import 'package:saily/datatypes/boat_info.dart';
import 'package:saily/datatypes/electricmotor_info.dart';
import 'package:saily/datatypes/endotermicmotor_info.dart';
import 'package:saily/datatypes/general_info.dart';
import 'package:saily/datatypes/highpowerbattery_info.dart';
import 'package:saily/datatypes/nmea2000_info.dart';
import 'package:saily/main.dart';
import 'package:saily/server/server.dart';
import 'package:saily/settings/settings_controller.dart';
import 'package:saily/tracks/fake_data.dart';
import 'package:saily/tracks/gpx_trips.dart';
import 'package:saily/utils/utils.dart';

class FakeServerInfo extends Server{
  FakeServerInfo({required this.settingsController}){
    fakeData = FakeData();
    fakeData.load_parse(cannesTrip);
    runFetchProcess(interval: Duration(milliseconds: 1000), callback: fetchProcess);
  }

  SettingsController settingsController;
  late FakeData fakeData;
  double SOG = 0;
  double SOC = 0;
  double RPM = 0;
  double motorTemp = 0;
  double inverterTemp = 0;

  Future<void> fetchProcess(Timer t) async {
    print("Running fetch..");
    
    // gps positioning
    settingsController.updateCurrentBoatPosition(Saily().homePosition);

    // gps count
    VTGInfo gpsCount = (await fetchVTGInfo()).getOrElse((){
      return VTGInfo(isFixed: false, SOG: 0, satellitesCount: 0);
    });
    settingsController.sendNVTGInfo(gpsCount);

    // battery info
    HighpowerbatteryInfo batteryInfo = (await fetchHighpowerbatteryInfo()).getOrElse((){
      return HighpowerbatteryInfo();
    });
    settingsController.sendHighPowerBatteryInfo(batteryInfo);

    // electric motor info
    ElectricmotorInfo electricmotorInfo = (await fetchElectricmotorInfo()).getOrElse((){
      return ElectricmotorInfo();
    });
    settingsController.sendElectricMotorInfo(electricmotorInfo);
  }

  Future<Either<InitError, String>> initServer() async {
    return Either.left(InitError(why: "initServer is abstract"));
  } 

  @override
  Future<Either<FetchError, ActuatorInfo>> fetchAcuatorInfo() async {
    // TODO: implement fetchAcuatorInfo
    throw UnimplementedError();
  }

  @override
  Future<Either<FetchError, BoatInfo>> fetchBoatInfo() async {
    // TODO: implement fetchBoatInfo
    throw UnimplementedError();
  }

  @override
  Future<Either<FetchError, ElectricmotorInfo>> fetchElectricmotorInfo() async {
    ElectricmotorInfo electricmotorInfo = ElectricmotorInfo();
    electricmotorInfo.motorRPM = RPM % 8000;
    electricmotorInfo.motorTemperature = motorTemp % 150;
    electricmotorInfo.inverterTemperature = inverterTemp % 150;

    RPM += 1;
    motorTemp += 0.1;
    inverterTemp += 0.3;

    return Either.right(electricmotorInfo);
  }

  @override
  Future<Either<FetchError, EndotermicmotorInfo>> fetchEndotermicmotorInfo() async {
    // TODO: implement fetchEndotermicmotorInfo
    throw UnimplementedError();
  }

  @override
  Future<Either<FetchError, GeneralInfo>> fetchGeneralInfo() async {
    // TODO: implement fetchGeneralInfo
    throw UnimplementedError();
  }

  @override
  Future<Either<FetchError, HighpowerbatteryInfo>> fetchHighpowerbatteryInfo() async {
    // battery info
    HighpowerbatteryInfo batteryInfo = HighpowerbatteryInfo();
    batteryInfo.SOC = (SOC++ % 100);
    batteryInfo.totalVoltage = SOC / 80;
    batteryInfo.power = SOG % 100;
    batteryInfo.batteryTemperature = SOC % 100;
    batteryInfo.bmsTemperature = (SOC + 10) % 100;

    SOG += 0.1;

    return Either.right(batteryInfo);
  }

  @override
  Future<Either<FetchError, VTGInfo>> fetchVTGInfo() async {
    bool isFixed = Random().nextBool();
    int count = Random().nextInt(10);
    final gpsCount = VTGInfo(isFixed: isFixed, satellitesCount: count, SOG: SOG % 150);

    return Either.right(gpsCount);
  }


  @override
  void runFetchProcess({required Duration interval, required void Function(Timer p1) callback}) {
    fetch = Timer.periodic(interval, callback);
  }

  @override
  void stopFetchProcess() {
    fetch.cancel();
  }
}