#pragma once

#include <string>
#include <features/data/models/number_trivia_model.hpp>
#include <core/exceptions/exceptions.hpp>
#include <core/utils/http_client.hpp>

struct RemoteDataSource {
    /// chiama un http://numberapi.com/{number}?json
    ///
    /// Throws a [ServerException] for all arror codes
    virtual NumberTriviaModel getConcreteNumberTrivia(int number) = 0;

    /// chiama un http://numberapi.com/random?json
    ///
    /// Throws a [ServerException] for all arror codes
    virtual NumberTriviaModel getRandomNumberTrivia() = 0;

    static std::string createConcreteUrl(int number) {
        return "http://numberapi.com/"+std::to_string(number)+"?json";
    }

    static std::string createRandomUrl() {
        return "http://numberapi.com/random?json";
    }
};

class RemoteDataSourceImpl : public RemoteDataSource{
    public:
    RemoteDataSourceImpl(std::shared_ptr<HttpClient> c) : client{c}{}
    std::shared_ptr<HttpClient> client;

    virtual NumberTriviaModel getConcreteNumberTrivia(int number) override {
        return _getConcreteOrRandomNumberTrivia(RemoteDataSource::createConcreteUrl(number));
    }

    virtual NumberTriviaModel getRandomNumberTrivia() override {
        return _getConcreteOrRandomNumberTrivia(RemoteDataSource::createRandomUrl());
    }

    /// @brief Get Concrete number or random number depending on the uri
    /// @param uri remote url to call
    /// @return NumberTriviaModel created using the uri response string
    /// @throws RemoteUriException if network cannot be reached
    /// @throws JsonParseException if result cannot be parsed
    NumberTriviaModel _getConcreteOrRandomNumberTrivia(std::string uri) {
        std::string jsonstring;

        try{
            jsonstring = client->curl(uri);
        }catch(TimeOutException &e){
            throw RemoteUriException();
        }

        NumberTriviaModel ret;

        ret = NumberTriviaModel::fromJsonString(jsonstring);

        return ret;
  }
};