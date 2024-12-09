#pragma once
#include <exception>
#include <string>

struct JsonParseException : public std::exception {
    JsonParseException() : w{""} {}
    JsonParseException(std::string _w) : w{_w} {}

    std::string w;

    virtual std::string what(){
        return w;
    }

    friend bool operator==(const JsonParseException &lh, const JsonParseException&rh){
        (void)(lh);
        (void)(rh);
        return true;
    }
};

struct CacheException : public std::exception {

};

struct RemoteUriException : public std::exception {

};


