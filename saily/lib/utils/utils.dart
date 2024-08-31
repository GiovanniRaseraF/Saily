import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'dart:io';

double scaleW(BuildContext c, double scale){
  return MediaQuery.of(c).size.width * scale;
}

double scaleH(BuildContext c, double scale){
  return MediaQuery.of(c).size.height * scale;
}

// just read file
String read_file({required String path}) => File("$path").readAsStringSync();

class HuracanMarine{
  final homePosition = LatLng(45.9034078,12.1159257);
  // static final compass = Image.asset("assets/icons/compass.png");
  // static final boat = Image.asset("assets/icons/boat.png");

  // // images
  // static final boat_image = Image.asset("assets/images/boatimage.png");
  // static final argonspeed_image = Image.asset("assets/images/argonspeed.png");
  // static final falconhybrid_image = Image.asset("assets/images/falconhybrid.png");


}

class HuracanMarineCan{
  //0=FullElectric; 1=Hybrid
  //2=SingleMotor  3=DualMotor
  static final boatTypes = {0: "FullElectric - SingleMotor", 1: "Hybrid", 2: "FullElectric - DualMotor", 3: "Hybrid"};
  static final themicEngineTypes = {0: "None", 1: "Mercury OOD 3.0L", 2: "Hyundai S270", 3: "Volvo Penta D4/D6"};
  static final electricMotorTypes = {0: "None", 1: "THOR 3000", 2: "THOR 6000"};
}

class Styles{
  Styles();
  Radius round = Radius.circular(80);
  RoundedRectangleBorder round_shape = RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20)),);

  Color primary_color = Color.fromARGB(255, 255, 255, 255);
  Color primary_2_color = Colors.blueGrey;
  //static Color primary_2_color = Colors.blueGrey;
  Color secondary_color = Colors.blueAccent.shade200;

  Color hm_green = Color.fromARGB(0, 44, 123, 12);
}

class StylesLight extends Styles {
  StylesLight(){
    super.primary_color = Color.fromARGB(255, 255, 255, 255);
    super.primary_2_color = Colors.blueGrey;
    //static Color primary_2_color = Colors.blueGrey;
    super.secondary_color = Colors.blueAccent.shade200;

    super.hm_green = Color.fromARGB(0, 44, 123, 12); 
  }
}

class StylesDark extends Styles {
  StylesDark(){
    primary_color = Color.fromARGB(255, 42, 41, 41);
    primary_2_color = Colors.blueGrey;

    secondary_color = Colors.orangeAccent.shade700;
    hm_green = Color.fromARGB(0, 44, 123, 12);
  }
}

///
/// bytes : list of bytes
/// from : first byte included
/// to : last byte NOT included
/// max 8
/// 
/// TODO: implement little endian
int from_bytes(List<int> bytes, int from, int to, Endian e, bool signed){
  int ret = 0;
  if(to <= from) throw Exception("Cannot parse from_bytes from: $from, to: $to");

  if(e == Endian.big){
    bool negative = (bytes[from] & 0x80) > 0;

    for(int i = to-1, off = 0; i >= from; i--, off+=8){
      int r = 0;
      if(i == from){
        r = ((signed && negative ? -((~bytes[i])+1 & 0xff) : bytes[i]) << off);
      }else{
        r = (bytes[i] << off);
      }
      ret += r;
    }
  }else if(e == Endian.little){
    bool negative = (bytes[to-1] & 0x80) > 0;

    for(int i = from, off = 0; i < to; i++, off+=8){
      int r = 0;
      if(i == to-1){
        r = ((signed && negative ? -((~bytes[i])+1 & 0xff) : bytes[i]) << off);
      }else{
        r = (bytes[i] << off);
      }
      ret += r;
    }
  }
  return ret;
}

String toBitString(int value){
  String ret = "";

  for(int i = 0; i < 32; i++){
    String v = (value & (1 << i)) > 0 ? "1" : "0";
    ret = v + ret;
  }

  return ret;
}


class HuracanMarineFaults {
  static String get502(int index){
  switch(index){
    case 0:
    return "Inverter_NOT_Ready";
    case 1:
    return "Inverter Overtemperature";
    case 2:
    return "Motor Overtemperature";
    case 3:
    return "Motor Temperature Sensor Defect";
    case 4:
    return "I2T Motor Protection";
    case 5:
    return "Low SOC Level";
    case 6:
    return "Over Charge";
    case 7:
    return "Throttle Not Zero";
    case 8:
    return "RESERVED";
    case 32:
    return "Overvoltage";
    case 33:
    return "Overcurrent";
    case 34:
    return "Undervoltage";
    case 35:
    return "Short Circuit Power Stage";
    case 36:
    return "Rotor Initial Position Error";
    case 37:
    return "HE Disconnected";
    case 38:
    return "HE Wrong Sequence";
    case 39:
    return "Aux Contactor";
    case 40:
    return "Inverter Overtemperature";
    case 41:
    return "IxT Power Protection";
    case 42:
    return "Motor Overtemperature";
    case 43:
    return "I2T Motor Protection";
    case 44:
    return "Emergency Input";
    case 45:
    return "Throttle Pot Disconnected";
    case 46:
    return "Brake Pot Disconnected";
    case 47:
    return "Clutch Pot Disconnected";
    case 48:
    return "PTC Power U Defect";
    case 49:
    return "PTC Power V Defect";
    case 50:
    return "PTC Power W Defect";
    case 51:
    return "Contactor";
    case 52:
    return "CRT CAN Link";
    case 53:
    return "RESERVED";
    case 61:
    return "Wrong Configuration";
    case 62:
    return "CANA Defect";
    case 63:
    return "CANB Defect";
    default:
    return "None";
  }
}

static String get506(int index){
  switch(index){
    case 0:
    return "Overcurrent";
    case 1:
    return "Overtemperature Cell";
    case 2:
    return "Overtemperature Board";
    case 3:
    return "Charge Over Voltage";
    case 4:
    return "Discharge Under Voltage";
    case 5:
    return "Low Energy";
    case 6:
    return "Charge Minimum Temperature";
    case 7:
    return "Charge Minimum Voltage";
    case 8:
    return "Maximum Current";
    case 9:
    return "Cell Max Temperature";
    case 10:
    return "Board Max Temperature";
    case 11:
    return "Charge Max Voltage";
    case 12:
    return "Discharge Min Voltage";
    case 13:
    return "Energy Level";
    case 14:
    return "Charge Minimum Voltage";
    case 15:
    return "Low Voltage";
    default:
    return "None";
  }
}

static String get50F(int index){
  switch(index){
    case 0:
    return "Ingresso di emergenza";
    case 1:
    return "Pulsante Start/Stop";
    case 2:
    return "Guasto attuatori";
    case 3:
    return "RESERVED";
    case 4:
    return "CAN bus manetta di comando";
    case 5:
    return "CAN bus attuatori";
    case 6:
    case 7:
    return "RESERVED";
    case 8:
    return "12V ECU basso";
    case 9:
    case 10:
    case 11:
    case 12:
    case 13:
    case 14:
    return "RESERVED";
    case 15:
    return "memoria eeprom difettosa";
    case 16:
    return "azionamento motore";
    case 17:
    return "motore termico";
    case 18:
    return "batteria alta tensione";
    case 19:
    return "RESERVED";
    case 20:
    return "CAN bus motore termico";
    case 21:
    return "CAN bus azionamento";
    case 22:
    return "CAN bus batteria";
    case 23:
    return "CAN bus bimotore";
    case 24:
    return "attuatore marce sinistro";
    case 25:
    return "attuatore marce destro";
    case 26:
    return "RESERVED";
    case 28:
    return "12V AUX basso";
    case 29:
    return "RESERVED";
    case 32:
    return "basso livello SOC";
    case 33:
    return "manetta accelerata";
    case 34:
    return "marcia inserita";
    case 35:
    return "cortocircuito pompa idroguida";
    case 36:
    return "pressostato pompa mare";
    case 37:
    return "cortocircuito pompa mare";
    case 38:
    return "pressostato pompa glicole";
    case 39:
    return "cortocircuito pompa glicole";
    case 40:
    return "cavo di ricarica inserito";
    case 41:
    return "12V ECU basso";
    case 42:
    return "12V AUX basso";
    case 43:
    return "RESERVED";
    case 44:
    return "velocità limitata";
    case 45:
    return "RESERVED";
    default:
    return "None";
  }
}
}
