#pragma once
#include <sstream>
#include <expected>
#include <iomanip>
#include <cmath>

#include <features/domain/entities/high_power_battery_info.hpp>
#include <core/exceptions/exceptions.hpp>
#include <core/utils/json_parser.hpp>

class HighPowerBatteryInfoModel: public HighPowerBatteryInfo{
    public: 
    HighPowerBatteryInfoModel() : HighPowerBatteryInfo{0, 0, 0, 0, 0, 0, 0, 0} {}
    HighPowerBatteryInfoModel(
        float _totalVoltage,
        float _totalCurrent,
        float _batteryTemperature,
        float _bmsTemperature,
        float _SOC,
        float _power,
        int _tte,
        float _auxBatteryVoltage) : HighPowerBatteryInfo{
            _totalVoltage,
            _totalCurrent,
            _batteryTemperature,
            _bmsTemperature,
            _SOC,
            _power,
            _tte,
            _auxBatteryVoltage
        } {}

    std::string toJsonString(){
        return HighPowerBatteryInfo::toString();
    }

    /// @param json: json representation of the data
    /// @return expected HighPowerBatteryInfoModel, unexpected JsonParseException otherwise
    static auto fromJsonString(std::string jsonstr) -> std::expected<HighPowerBatteryInfoModel, JsonParseException>{
        try{
            json parsed = json::parse(jsonstr);

            float totalVoltage = (((float)parsed["totalVoltage"]));
            float totalCurrent = (((float)parsed["totalCurrent"]));
            float batteryTemperature = (((float)parsed["batteryTemperature"]));
            float bmsTemperature = (((float)parsed["bmsTemperature"]));
            float SOC = (((float)parsed["SOC"]));
            float power = (((float)parsed["power"]));
            int tte = std::floor(((float)parsed["tte"]));
            float auxBatteryVoltage = (((float)parsed["auxBatteryVoltage"]));
            
            return HighPowerBatteryInfoModel(totalVoltage, totalCurrent, batteryTemperature, bmsTemperature, SOC, power, tte, auxBatteryVoltage);
        }catch (std::exception &e){
            return std::unexpected(JsonParseException());
        }
    }
};