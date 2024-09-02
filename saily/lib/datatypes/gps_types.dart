class GpsDataType {
  GpsDataType({required this.isFixed, required this.satellitesCount, required this.SOG});

  int satellitesCount = 0;
  bool isFixed = false;
  double SOG = 0;

  @override
  String toString() {
    return """{
      'satellitesCount' : $satellitesCount,
      'isFixed' : $isFixed,
      'SOG' : $SOG
    }""";
  }
}
