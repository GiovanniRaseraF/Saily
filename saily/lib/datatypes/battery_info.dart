class BatteryDataType {
  BatteryDataType(
      {required this.SOC,
      this.voltage = 0,
      this.current = 0,
      this.temp = 0,
      this.power = 0});
  int SOC = 0;
  double voltage = 0;
  double current = 0;
  double power = 0;
  double temp = 0;

  @override
  String toString() {
    return """{
      'SOC' : $SOC,
      'voltage' : $voltage,
      'current' : $current,
      'temp' : $temp
    }""";
  }
}
