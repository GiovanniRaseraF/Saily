#pragma once
#include <gtest/gtest.h>
#include <gmock/gmock.h>
#include <features/data/datasources/remote_data_source.hpp>

using ::testing::Return;
using ::testing::Throws;
using ::testing::Throw;

struct MockHttpClient : public HttpClient {
    public:
    MockHttpClient(){}
    ~MockHttpClient(){}
    MOCK_METHOD(std::string, curl, (std::string), (override));
};

/// @brief TODO: add support for client mocking
TEST(RemoteDataSource, TestInternet){
    std::shared_ptr<HttpClient> c = std::make_shared<HttpClient>();
    std::string uri = RemoteDataSource::createConcreteUrl(10);

    try{
        std::string ret = c->curl(uri);
        std::cout << ret << std::endl;
    }catch (TimeOutException &toe){
        std::cout << toe.what() << std::endl;
    }
}

/// @brief TODO: add support for client mocking
TEST(RemoteDataSource, ShouldReadFromRandom){
    std::shared_ptr<MockHttpClient> c = std::make_shared<MockHttpClient>();
    RemoteDataSourceImpl rds(c);
    NumberTriviaModel m(1, "random");

    std::string uri = RemoteDataSource::createRandomUrl();
    EXPECT_CALL(*c, curl(uri)).Times(1).WillRepeatedly(Return(m.toJsonString()));

    auto out = rds.getRandomNumberTrivia();

    EXPECT_TRUE(out == m);
}

/// @brief TODO: add support for client mocking
TEST(RemoteDataSource, ShouldReadThrowRemoteUriExceptionOnTimeOutException){
    std::shared_ptr<MockHttpClient> c = std::make_shared<MockHttpClient>();
    RemoteDataSourceImpl rds(c);
    int number = 10;
    std::string uri = RemoteDataSource::createConcreteUrl(number);

    EXPECT_CALL(*c, curl(uri)).Times(1).WillRepeatedly(Throw(TimeOutException("Test curl Timeout")));

    EXPECT_THAT(
        [&](){
            auto out = rds.getConcreteNumberTrivia(number);
        },
        Throws<RemoteUriException>()
    );
}

TEST(RemoteDataSource, ShouldReturnAGoonNumberTriviaOnGoodClient){
    std::shared_ptr<MockHttpClient> c = std::make_shared<MockHttpClient>();
    RemoteDataSourceImpl rds(c);
    int number = 10;
    std::string uri = RemoteDataSource::createConcreteUrl(number);
    NumberTriviaModel ret(10, "concrete");

    EXPECT_CALL(*c, curl(uri)).Times(1).WillRepeatedly(Return(ret.toJsonString()));

    auto out = rds.getConcreteNumberTrivia(number);

    EXPECT_TRUE(out == ret);
}
