import 'dart:async';

import 'package:dart_either/dart_either.dart';
import 'package:saily/datatypes/actuator_info.dart';
import 'package:saily/datatypes/boat_info.dart';
import 'package:saily/datatypes/electricmotor_info.dart';
import 'package:saily/datatypes/endotermicmotor_info.dart';
import 'package:saily/datatypes/general_info.dart';
import 'package:saily/datatypes/highpowerbattery_info.dart';
import 'package:saily/datatypes/nmea2000_info.dart';
import 'package:saily/datatypes/route_info.dart';

class FetchError{
  FetchError({required this.why});
  String why;

  @override
  String toString(){
    return why;
  }
}

class InitError{
  InitError({required this.why});
  String why;

  @override
  String toString(){
    return why;
  }
}

abstract class Server{
  late Timer fetch;

  Future<Either<InitError, String>> initServer() async {
    return Either.left(InitError(why: "initServer is abstract"));
  }

  Future<Either<FetchError, ActuatorInfo>> fetchAcuatorInfo() async {
    return Either.left(FetchError(why: "fetchActuatorInfo is abstract |"));
  }

  // fetch boat information from server
  Future<Either<FetchError, List<BoatInfo>>> fetchBoats() async {
    return Either.left(FetchError(why: "fetchBoatInfo is abstract |"));
  }
  
  Future<Either<FetchError, ElectricmotorInfo>> fetchElectricmotorInfo() async {
    return Either.left(FetchError(why: "fetchElectricmotorInfo is abstract |"));
  }

  Future<Either<FetchError, EndotermicmotorInfo>> fetchEndotermicmotorInfo() async {
    return Either.left(FetchError(why: "fetchEndotermicmotorInfo is abstract |"));
  }
  
  Future<Either<FetchError, GeneralInfo>> fetchGeneralInfo() async {
    return Either.left(FetchError(why: "fetchGeneralInfo is abstract |"));
  }

  Future<Either<FetchError, HighpowerbatteryInfo>> fetchHighpowerbatteryInfo() async {
    return Either.left(FetchError(why: "fetchHighpowerbatteryInfo is abstract |"));
  }

  Future<Either<FetchError, VTGInfo>> fetchVTGInfo() async {
    return Either.left(FetchError(why: "fetchVTGInfois abstract |"));
  }

  void setFetchProcess({required Duration interval, required void Function(Timer) callback}){
    fetch = Timer.periodic(interval, callback);
  }

  void stopFetchProcess(){
    fetch.cancel();
  }
}