#pragma once
#include <exception>
#include <string>

struct JsonParseException : public std::exception {
    JsonParseException() : w{""} {}
    JsonParseException(std::string _w) : w{w} {}

    std::string w;

    std::string what(){
        return w;
    }

    friend bool operator==(const JsonParseException &lh, const JsonParseException&rh){
        return true;
    }
};

struct CacheException : public std::exception {

};

struct RemoteUriException : public std::exception {

};