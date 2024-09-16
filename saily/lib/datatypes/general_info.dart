// From: Messaggi_CAN_Per_Huracan_Naviop_v1_9
// Author: Giovanni Rasera

// Tabella 1
enum DieselMotorModel{
  None,
  MercuryOOD3_0L,
  HyundaiS270,
  VolvoPentaD4_D6
}

// Tabella 2
enum ElectricMotorModel{
  None,
  THOR3000,
  THOR6000,
}

// Generale Info
class GeneralInfo {
  bool isHybrid     = false; // false = FullElectric , true = Hybrid
  bool isDualMotor  = false; // false = SingleMotor, true = DualMotor
  double versionProtocol      = 0.0; // factor 0.1
  double versionFWControlUnit = 0.0; // factor 0.01
  double versionFWDrive       = 0.0; // factor 0.01
  DieselMotorModel dieselMotorModel = DieselMotorModel.None; // Tabella 1
  ElectricMotorModel electricMotorModel = ElectricMotorModel.None; // Tabella 2
}