#pragma once
#include <gtest/gtest.h>
#include <gmock/gmock.h>
#include <core/utils/shared_preferences.hpp>

using ::testing::Return;
using ::testing::Throws;
using ::testing::Throw;

TEST(SharedPreferences, OpenAndCloseDatabase){
    SharedPreferences sp("test_pref.db");
    EXPECT_TRUE(sp.sq != nullptr);
    sp.~SharedPreferences();
    EXPECT_TRUE(sp.sq == nullptr);
}

TEST(SharedPreferences, StoreInt){
    SharedPreferences sp("test_1.db");
    
    {
        int in = 5436432;
        sp.storeInt("number", in);
        int out = sp.getInt("number");
        EXPECT_EQ(in, out);
    }
    {
        int in = 1111;
        sp.storeInt("number", in);
        int out = sp.getInt("number");
        EXPECT_EQ(in, out);
    }
    {
        int in = 432574;
        sp.storeInt("number", in);
        int out = sp.getInt("number");
        EXPECT_EQ(in, out);
    }
    sp.~SharedPreferences();
    SharedPreferences s2("test_1.db");
    int out = s2.getInt("number");
}

TEST(SharedPreferences, StoreString){
    SharedPreferences sp("test_1.db");
    
    {
        std::string in = "ciao fratello";
        sp.storeString("sometext", in);
        auto out = sp.getString("sometext");
        EXPECT_EQ(in, out);
    }
    {
        std::string in = "bella storia";
        sp.storeString("sometext", in);
        auto out = sp.getString("sometext");
        EXPECT_EQ(in, out);
    }
}

TEST(SharedPreferences, StoreJsonString){
    SharedPreferences sp("test_1.db");
    
    {
        std::string in = "{\"hello\" : \"ciaocomeva io sto bene e tu \"}";
        sp.storeString("jsontext", in);
        auto out = sp.getString("jsontext");
        EXPECT_EQ(in, out);
    }
}

TEST(SharedPreferences, StoreLongStringAndRetreaveIt){
    SharedPreferences sp("test_1.db");
    
    {
        std::string in = "{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}{helloc}";
        sp.storeString("jsontext", in);
        auto out = sp.getString("jsontext");
        EXPECT_EQ(in, out);
    }
}

TEST(SharedPreferences, SQLInjection){
    SharedPreferences sp("test_1.db");
    //SharedPreferences::log = true; 
    {
        sp.storeString("injection", "");

        // this can drop injection table
        std::string in = "(drop table injection;)";
        sp.storeString("injection_executer", in);
        
        auto out = sp.getString("injection");
        auto out_executor = sp.getString("injection_executer");
        EXPECT_EQ(out_executor, in);
        EXPECT_EQ("", out);
    }
    //SharedPreferences::log = false; 
}

TEST(SharedPreferences, GetNotPresentValue){
    SharedPreferences sp("test_1.db");
    
    EXPECT_THAT(
        [&](){
            auto out = sp.getString("this_is_not_in_db");
        },
        Throws<SharedPreferenceException>());

    {
        std::string in = "{\"hello\" : \"ciaocomeva io sto bene e tu \"}";
        sp.storeString("jsontext", in);
        auto out = sp.getString("jsontext");
        EXPECT_EQ(in, out);
    }
    
    EXPECT_THAT(
        [&](){
            auto out = sp.getString("this_is_not_in_db");
        },
        Throws<SharedPreferenceException>());
    {
        std::string in = "{\"hello\" : \"ciaocomeva io sto bene e tu \"}";
        sp.storeString("jsontext", in);
        auto out = sp.getString("jsontext");
        EXPECT_EQ(in, out);
    }
}

TEST(SharedPreferences, PeriodicQuery){
    SharedPreferences sp("test_periodic.db");

    for(int i = 0; i < 10; i++) 
    {
        std::string in = "{ number:" + std::to_string(i) + ", text:fjdkslafjkdsa}";
        sp.storeString("jsontext", in);
        auto out = sp.getString("jsontext");
        EXPECT_EQ(in, out);
    }
}

TEST(SharedPreferences, BadStringPurify){
    
    SharedPreferences sp("test_badstring.db");
    {
        std::string bad_original = "{\"number\" : 13,\"text\" : \"13 is the number of loaves in a \"baker's dozen\".\",\"found\" : true,\"type\" : \"trivia\"}";
        // "near \"s\": syntax error"

        // must call purify
        sp.storeString("jsontext", bad_original);
        auto good_out = sp.getString("jsontext");
        EXPECT_EQ(bad_original, good_out );
    }
}