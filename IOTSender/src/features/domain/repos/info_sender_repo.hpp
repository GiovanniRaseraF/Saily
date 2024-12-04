#pragma once
#include <future>
#include <thread>
#include <string>
#include <variant>
#include <expected>
#include <core/exceptions/exceptions.hpp>
#include <features/data/dataends/remote_data_end.hpp>
#include <features/domain/entities/actuator_info.hpp>
#include <features/domain/entities/high_power_battery_info.hpp>


struct InfoSenderRepo{
    virtual ~InfoSenderRepo(){}

    virtual auto sendActuatorInfo(ActuatorInfo acti) -> std::expected<BoatInfoSent, BoatInfoNOTSent> = 0;

    virtual auto sendHighPowerBatteryInfo(HighPowerBatteryInfo hpbi) -> std::expected<BoatInfoSent, BoatInfoNOTSent> = 0;
    
};