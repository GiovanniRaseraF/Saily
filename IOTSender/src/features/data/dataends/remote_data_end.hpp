#pragma once

#include <string>
#include <expected>
#include <core/exceptions/exceptions.hpp>
#include <core/utils/http_client.hpp>
#include <features/domain/entities/boat_credential.hpp>

struct RemoteDataEnd {
    virtual std::expected<BoatInfoSent, BoatInfoNOTSent> sendData(std::string endpoint, BoatCredential credential, std::string data) = 0;
};

struct RemoteDataEndImpl : public RemoteDataEnd{
    public:
    RemoteDataEndImpl(std::shared_ptr<HttpClient> _client) : client{_client}{}
    std::shared_ptr<HttpClient> client;

    virtual std::expected<BoatInfoSent, BoatInfoNOTSent> sendData(std::string endpoint, BoatCredential credential, std::string data) override {}
};