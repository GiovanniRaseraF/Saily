#pragma once

#include <string>
#include <expected>
#include <core/exceptions/exceptions.hpp>
#include <core/utils/http_client.hpp>
#include <features/domain/entities/boat_credential.hpp>

struct BoatInfoSent {
    BoatInfoSent(): ret{""}{}
    BoatInfoSent(std::string _ret) : ret{_ret}{}
    std::string ret;
    
    std::string getResponse(){
        return ret;
    }

    friend bool operator==(const BoatInfoSent&lh, const BoatInfoSent&rh){
        return true;
    }
};

struct BoatInfoNOTSent {
    BoatInfoNOTSent(){}
    
    friend bool operator==(const BoatInfoNOTSent&lh, const BoatInfoNOTSent&rh){
        return true;
    }
};

struct RemoteDataEnd {
    virtual std::expected<BoatInfoSent, BoatInfoNOTSent> sendData(std::string endpoint, BoatCredential credential, std::string data) = 0;

    virtual std::string getSite(){
        return "huracanpower.com";
    }
};

struct RemoteDataEndImpl : public RemoteDataEnd{
    public:
    RemoteDataEndImpl(std::shared_ptr<HttpSendClient> _client) : client{_client}{}
    std::shared_ptr<HttpSendClient> client;

    virtual std::expected<BoatInfoSent, BoatInfoNOTSent> sendData(std::string endpoint, BoatCredential credential, std::string actual_message) override {
        // const data = `boat_id=${boat_id}&mqtt_user=${mqtt_user}&mqtt_password=${mqtt_password}&actual_message=${actualStr}`;

        std::string authData = "";
        authData += "boat_id="+credential.boat_id;
        authData += "&mqtt_user="+credential.mqtt_user;
        authData += "&mqtt_password="+credential.mqtt_password;
        authData += "&actual_message="+actual_message;

        auto ret = client->curl(getSite(), endpoint, authData); 

        if(ret.has_value()) {
            auto val = *ret;
            //std::cout << "sendData: " << val << std::endl;
            return BoatInfoSent(val);
        }else{
            auto err = ret.error();
            return std::unexpected(BoatInfoNOTSent());
        }

        return std::unexpected(BoatInfoNOTSent());
    }
};