// From: Messaggi_CAN_Per_Huracan_Naviop_v1_9
// Author: Giovanni Rasera

class HighpowerbatteryInfo {
  double totalVoltage = 0.0; // factor 0.1 V
  double totalCurrent = 0.0; // factor 0.1 A
  double batteryTemperature = 0.0;  // C
  double bmsTemperature = 0.0;      // C
  double SOC = 0.0;                 // %

  double power = 0.0; // factor 0.1 KW +consumata -assorbita
  int tte = 0;        // min
  double auxBatteryVoltage = 0.0; // factor 0.1 V
}