#pragma once
#include <gtest/gtest.h>
#include <gmock/gmock.h>
#include <features/data/models/actuator_info_model.hpp>
#include <core/utils/json.hpp>
using ::testing::Return;
using ::testing::Throws;
using ::testing::Throw;

TEST(Models, ActuatorInfoModelToJson){
    ActuatorInfoModel from(1.33, 2, 3, 4.4);
    ActuatorInfoModel value{};

    auto ret_from = from.toJsonString();
    const auto result = ActuatorInfoModel::fromJsonString(ret_from);

    if(result.has_value()){
        value = *result;
    }else if(result.error() == JsonParseException()){
       FAIL(); 
    }

    EXPECT_TRUE(value.toJsonString() == from.toJsonString());
}

TEST(Model, JsonParsingExceptionOnEmptyString){
    const auto result = ActuatorInfoModel::fromJsonString("");
    if(result.has_value()) FAIL();
    EXPECT_TRUE(result.error() == JsonParseException());
}

TEST(Model, JsonParsingExceptionOnUnparsableString){
    const auto result = ActuatorInfoModel::fromJsonString("fdsa[fdsa]");
    if(result.has_value()) FAIL();
    EXPECT_TRUE(result.error() == JsonParseException());
}

TEST(Model, JsonParsingExceptionOnParsableStringBadJsonAttributes){
    const auto result = ActuatorInfoModel::fromJsonString("{\"pedal\" : 1,\"wrong\" : 2,\"wrong2\" : 3, \"pedalTrim\" : 4}");
    if(result.has_value()) FAIL();
    EXPECT_TRUE(result.error() == JsonParseException());
}

TEST(Model, JsonParsingExceptionOnParsableStringMissinJsonAttribute){
    const auto result = ActuatorInfoModel::fromJsonString("{\"pedal\" : 1}");
    if(result.has_value()) FAIL();
    EXPECT_TRUE(result.error() == JsonParseException());
}

TEST(Model, JsonParsingExceptionOnParsableStringNumberAttributeIsDouble){
    const auto j1 = "{\"pedal\" : 1.1,\"requestedGear\" : 2,\"validatedGear\" : 3,\"pedalTrim\" : 4.44}";
    const auto j2 = "{\"pedal\" : 1.1,\"requestedGear\" : 2.0,\"validatedGear\" : 3.0,\"pedalTrim\" : 4.44}";
    const auto result1 = ActuatorInfoModel::fromJsonString(j1);
    const auto result2 = ActuatorInfoModel::fromJsonString(j2);

    if(result1.has_value() && result1.has_value()){
        const auto v1 = *result1;        
        const auto v2 = *result2;        
    }else{
        FAIL();
    }
}