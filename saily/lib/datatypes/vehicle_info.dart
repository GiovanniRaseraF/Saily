// From: Messaggi_CAN_Per_Huracan_Naviop_v1_9
// Author: Giovanni Rasera

enum VehicleStatus {
  WAIT,                   // 0
  ENABLE_BMS_E_INVERTER,  // 10
  CLOSE_TELE_BATT,        // 20
  ENABLE_INVERTER,        // 30
  INVERTER_OFF,           // ...
  RUNNING_EV_MODE,
  RUNNING_RIGENERAZIONE,
  FAULT_ELETTRICO,
  SHUTDOWN,
  VEICOLO_IN_RICARICA,
  MODALITA_SOLO_DIESEL    // 130
}

class VehicleInfo {
  VehicleStatus vehicleStatus = VehicleStatus.WAIT;
  bool isHybrid = false;
  bool isElectric = false;
  bool isDiesel = false;
  bool isSeaWaterPressureOK = false;
  bool isGlicolePressureOK = false;
  bool isLowSocLevel = false;
  double sealINTemperature = 0.0; // C
  double sealOUTTemperature = 0.0; // C
  double glicoleINTemperature = 0.0; // C
  double glicoleOUTTemperature = 0.0; // C
  bool isECUOn = false;
  bool isDCUOn = false;
  double voltageToECU = 0.0; // factor 0.1 V

  int timecounter = 0; //min
  int timecounterElectricMotor = 0; //min
  int timecounterDieselMotor = 0; //min
}