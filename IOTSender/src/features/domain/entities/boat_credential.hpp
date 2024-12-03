#pragma once
#include <string>
#include <sstream>

class BoatCredential {
public:
    BoatCredential(std::string _mqtt_user, std::string _mqtt_password) : mqtt_user{_mqtt_user}, mqtt_password{_mqtt_password}{}
    
    std::string mqtt_user = "";
    std::string mqtt_password= "";
};