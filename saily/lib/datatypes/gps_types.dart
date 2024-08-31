class GpsCountType {
  GpsCountType({required this.isFixed, required this.satellitesCount});

  int satellitesCount = 0;
  bool isFixed = false;

  @override
  String toString() {
    return """{
      'satellitesCount' : $satellitesCount,
      'isFixed' : $isFixed
    }""";
  }
}
