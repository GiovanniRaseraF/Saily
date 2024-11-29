#pragma once
#include <core/exceptions/exceptions.hpp>
#include <exception>

#include <core/utils/commands.hpp>

struct HttpClient {
    ~HttpClient(){}
    HttpClient(){}

    std::chrono::duration<long long> MAX_DURATION = std::chrono::seconds(200);

    virtual std::string curl(std::string site){
        return commands::curl(site);
    }
};