#pragma once
#include <string>
#include <sstream>

class HighPowerBatteryInfo{
public:
    HighPowerBatteryInfo() : HighPowerBatteryInfo{0, 0, 0, 0, 0, 0, 0, 0} {};
    HighPowerBatteryInfo(
        float _totalVoltage,
        float _totalCurrent,
        float _batteryTemperature,
        float _bmsTemperature,
        float _SOC,
        float _power,
        int _tte,
        float _auxBatteryVoltage) : totalVoltage{_totalVoltage},
                                    totalCurrent{_totalCurrent},
                                    batteryTemperature{_batteryTemperature},
                                    bmsTemperature{_bmsTemperature},
                                    SOC{_SOC},
                                    power{_power},
                                    tte{_tte},
                                    auxBatteryVoltage{_auxBatteryVoltage} {}

    float totalVoltage = 0.0;
    float totalCurrent = 0.0;
    float batteryTemperature = 0.0;
    float bmsTemperature = 0.0;
    float SOC = 0.0;
    float power = 0.0;
    int tte = 0;
    float auxBatteryVoltage = 0.0;

    std::string toString(){
        std::ostringstream ss{}; 

        ss << "{";
        ss << "\"totalVoltage\" : " << totalVoltage << ",";
        ss << "\"totalCurrent\" : " << totalCurrent << ",";
        ss << "\"batteryTemperature\" : " << batteryTemperature << ",";
        ss << "\"bmsTemperature\" : " << bmsTemperature << ",";
        ss << "\"SOC\" : " << SOC << ",";
        ss << "\"power\" : " << power << ",";
        ss << "\"tte\" : " << tte << ",";
        ss << "\"auxBatteryVoltage\" : " << auxBatteryVoltage;
        ss << "}";

        return ss.str();
    }

    friend bool operator==(const HighPowerBatteryInfo&lh, const HighPowerBatteryInfo&rh){
    return 
        lh.totalVoltage == rh.totalVoltage &&
        lh.totalCurrent == rh.totalCurrent &&
        lh.batteryTemperature == rh.batteryTemperature &&
        lh.bmsTemperature == rh.bmsTemperature &&
        lh.SOC == rh.SOC &&
        lh.power == rh.power &&
        lh.tte == rh.tte &&
        lh.auxBatteryVoltage == rh.auxBatteryVoltage;
    }
};