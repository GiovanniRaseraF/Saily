
#pragma once
#include <gtest/gtest.h>
#include <gmock/gmock.h>
#include "features/domain/entities/actuator_info.hpp"

class MockActuatorInfo : public ActuatorInfo {
    public:
    MOCK_METHOD(std::string, toString, (), (override));
};

using ::testing::Return;
TEST(MockActuatorInfoTest, toString){
    std::string return_value = "";

    MockActuatorInfo mockActuatorInfo;
    ON_CALL(mockActuatorInfo, toString).WillByDefault(Return(return_value)); 
    EXPECT_CALL(mockActuatorInfo, toString);
    std::string result = mockActuatorInfo.toString();

    EXPECT_EQ(result, return_value);
}
