#pragma once
#include <sstream>
#include <expected>
#include <iomanip>
#include <cmath>

#include <features/domain/entities/actuator_info.hpp>
#include <core/exceptions/exceptions.hpp>
#include <core/utils/json_parser.hpp>

class ActuatorInfoModel: public ActuatorInfo{
    public:
    ActuatorInfoModel() {}
    ActuatorInfoModel(float _pedal, int _requestedGear, int _validatedGear, float _pedalTrim) : 
        ActuatorInfo{_pedal, _requestedGear, _validatedGear, _pedalTrim} {}

    std::string toJsonString(){
        return ActuatorInfo::toString();
    }

    /// @param json: json representation of the data
    /// @return expected ActuatorInfoModel, unexpected JsonParseException otherwise
    static auto fromJsonString(std::string jsonstr) -> std::expected<ActuatorInfoModel, JsonParseException>{
        try{
            json parsed = json::parse(jsonstr);
            
            float pedal = ((float)parsed["pedal"]);
            int requestedGear = std::floor((float)parsed["requestedGear"]);
            int validatedGear = std::floor((int)parsed["validatedGear"]);
            float pedalTrim = ((float)parsed["pedalTrim"]);
            
            return ActuatorInfoModel(pedal, requestedGear, validatedGear, pedalTrim);
        }catch (std::exception &e){
            return std::unexpected(JsonParseException());
        }
    }
};