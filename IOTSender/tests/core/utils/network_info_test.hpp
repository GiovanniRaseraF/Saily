#pragma once
#include <gtest/gtest.h>
#include <gmock/gmock.h>
#include <core/utils/network_info.hpp>

using ::testing::Return;
using ::testing::Throws;
using ::testing::Throw;

TEST(TestConnection, JustRun){
    ConnectionTester ct;

    // just check connection
    auto ret = ct.checkInternetConnection();
}

struct MockConnectionTester : public ConnectionTester {
    public:
    MOCK_METHOD(bool, checkInternetConnection, (), (override));
};

TEST(NetworkInfo, OnNoConnectionReturnFalse){
    std::shared_ptr<MockConnectionTester> mockct = std::make_shared<MockConnectionTester>();
    NetworkInfo netinfo(mockct);

    ON_CALL(*mockct, checkInternetConnection).WillByDefault(Return(false));
    EXPECT_CALL(*mockct, checkInternetConnection);

    auto c = netinfo.isConnected();

    EXPECT_FALSE(c);
}

TEST(NetworkInfo, OnConnectionReturnTrue){
    std::shared_ptr<MockConnectionTester> mockct = std::make_shared<MockConnectionTester>();
    NetworkInfo netinfo(mockct);

    ON_CALL(*mockct, checkInternetConnection).WillByDefault(Return(true));
    EXPECT_CALL(*mockct, checkInternetConnection);

    auto c = netinfo.isConnected();

    EXPECT_TRUE(c);
}
