#pragma once
#include <gtest/gtest.h>
#include <gmock/gmock.h>
#include <core/utils/commands.hpp>

using ::testing::Return;
using ::testing::Throws;
using ::testing::Throw;

TEST(TestCommands, JustRun){
    using namespace commands;
    auto ret = curlDataSend(HTTP_PROTOCOL::https, "www.google.com", "", "q=hello");
    
    if(ret.has_value()){
        auto value = *ret; 
        EXPECT_FALSE(value == "");
    }else{
        FAIL(); 
    }
}

TEST(TestCommands, JustContactServer){
    using namespace commands;
    auto ret = curlDataSend(HTTP_PROTOCOL::https, "huracanpower.com", "ping", "");

    if(ret.has_value()){
        auto value = *ret; 
        EXPECT_FALSE(value == "");
    }else{
        FAIL(); 
    }
}

TEST(TestCommands, WrongUrlTimeOutException){
    using namespace commands;
    auto ret = curlDataSend(HTTP_PROTOCOL::https, "wrong_url_time_out_exception.com", "", "");

    if(ret.has_value()){
        FAIL(); 
    }else{
        auto value = ret.error();
    }
}
