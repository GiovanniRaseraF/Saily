#pragma once
#include <future>
#include <thread>
#include <string>
#include <variant>
#include <expected>
#include "features/domain/entities/actuator_info.hpp"
#include "features/domain/entities/high_power_battery_info.hpp"

class InfoSent {};
class InfoNOTSent {};

struct InfoSenderRepo{
    virtual ~InfoSenderRepo(){}

    virtual auto sendActuatorInfo() -> std::expected<InfoSent, InfoNOTSent> {
        std::unexpected(InfoNOTSent);
    };

    virtual auto sendHighPowerBatteryInfo() -> std::expected<InfoSent, InfoNOTSent> {
        std::unexpected(InfoNOTSent);
    };
};