// From: Messaggi_CAN_Per_Huracan_Naviop_v1_9
// Author: Giovanni Rasera

enum GlowStatus{
  OFF, ON
}

enum DieselStatus {
  WAIT,           // 0
  WAIT_CRANKING,  // 10
  RUNNING,        // 50
  FAULT           // 110
}

class EndotermicmotorInfo {
  int motorRPM = 0; // RPM
  double refrigerationTemperature = 0.0; // C
  double batteryVoltage = 0.0; // factor 0.1 V
  int throttlePedalPosition = 0; // %
  GlowStatus glowStatus = GlowStatus.OFF;
  DieselStatus dieselStatus = DieselStatus.WAIT;
  int fuelLevel1 = 0; // %
  int fuelLevel2 = 0; // %
}