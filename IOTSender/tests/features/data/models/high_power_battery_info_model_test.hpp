#pragma once
#include <gtest/gtest.h>
#include <gmock/gmock.h>
#include <features/data/models/high_power_battery_info_model.hpp>
#include <core/utils/json.hpp>
using ::testing::Return;
using ::testing::Throws;
using ::testing::Throw;

TEST(HighPowerBatteryInfoModelTests, HighPowerBatteryInfoModelToJson){
    HighPowerBatteryInfoModel from(1.1, 2.2, 3.3, 4.4, 5.5, 6.7, 7.7, 8.8);
    HighPowerBatteryInfoModel value{};

    auto ret_from = from.toJsonString();
    const auto result = HighPowerBatteryInfoModel::fromJsonString(ret_from);

    if(result.has_value()){
        value = *result;
    }else if(result.error() == JsonParseException()){
       FAIL(); 
    }

    EXPECT_TRUE(value.toJsonString() == from.toJsonString());
}

TEST(HighPowerBatteryInfoModelTests, JsonParsingExceptionOnEmptyString){
    const auto result = HighPowerBatteryInfoModel::fromJsonString("");
    if(result.has_value()) FAIL();
    EXPECT_TRUE(result.error() == JsonParseException());
}

TEST(HighPowerBatteryInfoModelTests, JsonParsingExceptionOnUnparsableString){
    const auto result = HighPowerBatteryInfoModel::fromJsonString("fdsa[fdsa]");
    if(result.has_value()) FAIL();
    EXPECT_TRUE(result.error() == JsonParseException());
}

TEST(HighPowerBatteryInfoModelTests, JsonParsingExceptionOnParsableStringBadJsonAttributes){
    const auto j2 = "{\"totalVoltage\" : 1.1,\"wrong\" : 2.2,\"batteryTemperature\" : 3.3,\"bmsTemperature\" : 4.4,\"SOC\" : 5.5,\"power\" : 6.7,\"tte\" : 7,\"auxBatteryVoltage\" : 8.8}";
    const auto result = HighPowerBatteryInfoModel::fromJsonString(j2);
    if(result.has_value()) FAIL();
    EXPECT_TRUE(result.error() == JsonParseException());
}

TEST(HighPowerBatteryInfoModelTests, JsonParsingExceptionOnParsableStringMissinJsonAttribute){
    const auto result = HighPowerBatteryInfoModel::fromJsonString("{\"h\" : 1}");
    if(result.has_value()) FAIL();
    EXPECT_TRUE(result.error() == JsonParseException());
}

TEST(HighPowerBatteryInfoModelTests, JsonParsingExceptionOnParsableStringNumberAttributeIsDouble){
    const auto j1 = "{\"totalVoltage\" : 1.1,\"totalCurrent\" : 2.2,\"batteryTemperature\" : 3.3,\"bmsTemperature\" : 4.4,\"SOC\" : 5.5,\"power\" : 6.7,\"tte\" : 7.1,\"auxBatteryVoltage\" : 8.8}";
    const auto j2 = "{\"totalVoltage\" : 1.1,\"totalCurrent\" : 2.2,\"batteryTemperature\" : 3.3,\"bmsTemperature\" : 4.4,\"SOC\" : 5.5,\"power\" : 6.7,\"tte\" : 7,\"auxBatteryVoltage\" : 8.8}";
    const auto result1 = HighPowerBatteryInfoModel::fromJsonString(j1);
    const auto result2 = HighPowerBatteryInfoModel::fromJsonString(j2);

    if(result1.has_value() && result1.has_value()){
        const auto v1 = *result1;        
        const auto v2 = *result2;        
    }else{
        FAIL();
    }
}