// author: Giovanni Rasera
// for now the implementation in fake

class VTGInfo {
  VTGInfo({required this.isFixed, required this.satellitesCount, required this.SOG});

  int satellitesCount = 0;
  bool isFixed = false;
  double SOG = 0; // usualy in km/hr from NMEA2000

  @override
  String toString() {
    return """{
      'satellitesCount' : $satellitesCount,
      'isFixed' : $isFixed,
      'SOG' : $SOG
    }""";
  }
}
