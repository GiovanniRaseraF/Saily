#pragma once
#include <future>
#include <thread>
#include <string>
#include <variant>
#include <expected>
#include <core/utils/network_info.hpp>
#include <features/domain/entities/boat_credential.hpp>
#include <features/domain/repos/info_sender_repo.hpp>
#include <features/domain/entities/actuator_info.hpp>
#include <features/domain/entities/high_power_battery_info.hpp>

struct InfoSenderRepoImpl : public InfoSenderRepo{
    InfoSenderRepoImpl(
        BoatCredential _credentials,
        std::shared_ptr<RemoteDataEnd> _rde
    ) : credentials{_credentials}, rde{_rde} {}

    BoatCredential credentials;
    std::shared_ptr<RemoteDataEnd> rde;

    virtual auto sendActuatorInfo(ActuatorInfo acti) -> std::expected<BoatInfoSent, BoatInfoNOTSent> {
        auto func = [&](){
            return rde->sendData("send_acti", credentials, acti.toString());
        };

        return _sendActualData(func);
    };

    virtual auto sendHighPowerBatteryInfo(HighPowerBatteryInfo hpbi) -> std::expected<BoatInfoSent, BoatInfoNOTSent> {
        auto func = [&](){
            return rde->sendData("send_hpbi", credentials, hpbi.toString());
        };

        return _sendActualData(func);
    };

    private:
    auto _sendActualData(std::function<std::expected<BoatInfoSent, BoatInfoNOTSent>(void)> func) -> std::expected<BoatInfoSent, BoatInfoNOTSent> {
        auto result = func(); 
        return result;
    }
};