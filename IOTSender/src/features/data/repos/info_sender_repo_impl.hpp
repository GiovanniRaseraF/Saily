#pragma once
#include <future>
#include <thread>
#include <string>
#include <variant>
#include <expected>
#include <features/domain/repos/info_sender_repo.hpp>
#include "features/domain/entities/actuator_info.hpp"
#include "features/domain/entities/high_power_battery_info.hpp"

struct InfoSenderRepoImpl : public InfoSenderRepo{
    virtual ~InfoSenderRepoImpl(
    ){}

    // std::shared_ptr<NetworkInfo> networkInfo;
    // std::shared_ptr<LocalDataSend> localDataSend;
    // std::shared_ptr<RemoteDataSend> remoteDataSend;

    virtual auto sendActuatorInfo() -> std::expected<InfoSent, InfoNOTSent> override {
    };

    virtual auto sendHighPowerBatteryInfo() -> std::expected<InfoSent, InfoNOTSent> override {
    };
};