#pragma once
#include <string>
#include <sstream>

class BoatCredential {
public:
    BoatCredential(
        std::string _boat_id, 
        std::string _mqtt_user, 
        std::string _mqtt_password) : boat_id{_boat_id} ,mqtt_user{_mqtt_user}, mqtt_password{_mqtt_password}{}
    
    std::string boat_id = "";
    std::string mqtt_user = "";
    std::string mqtt_password= "";
};