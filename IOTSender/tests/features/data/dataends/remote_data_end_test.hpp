#pragma once
#include <gtest/gtest.h>
#include <gmock/gmock.h>

#include <features/data/dataends/remote_data_end.hpp>

using ::testing::Return;
using ::testing::Throws;
using ::testing::Throw;

struct MockHttpSendClient : public HttpSendClient {
    public:
    MockHttpSendClient(){}
    ~MockHttpSendClient(){}
    MOCK_METHOD((std::expected<std::string, TimeOutException>), curl, ((std::string), (std::string), (std::string)), (override));
};

/// @brief TODO: add support for client mocking
TEST(RemoteDataEnd, ShouldSend){
    std::shared_ptr<MockHttpSendClient> c = std::make_shared<MockHttpSendClient>();
    RemoteDataEndImpl rds(c);

    std::string endpoint = "ping";
    BoatCredential bc{"", "", ""};
    
    EXPECT_CALL(*c, curl("huracanpower.com", endpoint, "boat_id=&mqtt_user=&mqtt_password=&actual_message={}")).Times(1).WillRepeatedly(Return("{}"));

    auto out = rds.sendData(endpoint, bc, "{}");
    
    if(out.has_value()){
        auto val = *out;
    }else{
        FAIL();
    }
}

TEST(RemoteDataEnd, BoatNotExists){
    std::shared_ptr<HttpSendClient> c = std::make_shared<HttpSendClient>();
    RemoteDataEndImpl rds(c);

    std::string endpoint = "send_emi";
    BoatCredential bc{"0x0", "fake", "false"};
    
    auto out = rds.sendData(endpoint, bc, "{}");
    
    if(out.has_value()){
        auto val = *out;
        std::cout << val.getResponse() << std::endl;
    }else{
        FAIL();
    }
}

