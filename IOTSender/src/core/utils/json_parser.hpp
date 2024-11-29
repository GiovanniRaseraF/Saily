#pragma once
#include <sstream>
#include <core/utils/json.hpp>

using nlohmann::json;

struct JsonParser {
    JsonParser(){}

    virtual json parse(const std::string s){
        try{
            return json::parse(s);
        }catch (json::exception &je){
            throw new JsonParseException();
        }
    }

    //template <typename T>
    //T get(json j, std::string vname){
    //    return static_cast<T>(j[vname]);
    //}
    double getDouble(json j, std::string vname){
        if(j[vname].is_number_float()){
            return static_cast<double>(j[vname]);
        }else{
            throw JsonParseException();
        }
    }
    int getInt(json j, std::string vname){
       double r = getDouble(j, vname);
       return (int) std::floor(r);
    }
    std::string getString(json j, std::string vname){
        if(j[vname].is_string()){
            return static_cast<std::string>(j[vname]);
        }else{
            throw new JsonParseException();
        }
    }
};
