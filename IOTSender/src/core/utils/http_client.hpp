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

struct HttpSendClient{
    ~HttpSendClient(){}
    HttpSendClient(){}

    virtual std::expected<std::string, TimeOutException> curl(std::string site, std::string endpoint, std::string data){
        return commands::curlDataSend(commands::HTTP_PROTOCOL::https, site, endpoint, data);
    }
};