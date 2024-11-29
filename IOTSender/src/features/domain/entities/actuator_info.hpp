#pragma once
#include <string>
#include <sstream>
#include "data_info.hpp"

class ActuatorInfo {
public:
    ActuatorInfo() : pedal{0.0}, requestedGear{0}, validatedGear{0}, pedalTrim{0.0}{}
    ActuatorInfo(float _pedal, int _requestedGear, int _validatedGear, float _pedalTrim) : pedal{_pedal}, requestedGear{_requestedGear}, validatedGear{_validatedGear}, pedalTrim{_pedalTrim}{}

    float pedal; 
    int requestedGear; 
    int validatedGear;
    float pedalTrim;

    virtual std::string toString() {
       std::ostringstream ss{}; 

       ss << "{";
       ss << "\"pedal\" : " << pedal << ",";
       ss << "\"requestedGear\" : " << requestedGear << ",";
       ss << "\"validatedGear\" : " << validatedGear << ",";
       ss << "\"pedalTrim\" : " << pedalTrim;
       ss << "}";

       return ss.str();
    }
        
    friend bool operator==(const ActuatorInfo&lh, const ActuatorInfo&rh){
        return 
            lh.pedal == rh.pedal &&
            lh.requestedGear == rh.requestedGear &&
            lh.validatedGear == rh.validatedGear &&
            lh.pedalTrim == rh.pedalTrim;
    }
};