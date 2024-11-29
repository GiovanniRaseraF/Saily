#pragma once

#include <future>
#include <thread>
#include <string>
#include <variant>
#include <memory>
#include <core/utils/network_info.hpp>

#include <features/data/models/number_trivia_model.hpp>
#include <features/data/datasources/local_data_source.hpp>
#include <features/data/datasources/remote_data_source.hpp>

#include <features/domain/repos/number_trivia_repo.hpp>

class NumberTriviaRepoImpl : public NumberTriviaRepo{
    public:
    NumberTriviaRepoImpl(
        std::shared_ptr<NetworkInfo> ni,
        std::shared_ptr<LocalDataSource> lds, 
        std::shared_ptr<RemoteDataSource> rds
    ) : networkInfo{ni}, localDataSource{lds}, remoteDataSource{rds}  {}

    std::shared_ptr<NetworkInfo> networkInfo;
    std::shared_ptr<LocalDataSource> localDataSource;
    std::shared_ptr<RemoteDataSource> remoteDataSource;

    virtual NumberTrivia getConcreteNumberTrivia(int number) override{
        auto func = [&](){
            return remoteDataSource->getConcreteNumberTrivia(number);
        };
        
        return _getConcreteOrRandomNumberTrivia(func);
    };

    virtual NumberTrivia getRandomNumberTrivia() override {
        auto func = [&](){
            return remoteDataSource->getRandomNumberTrivia();
        };

        return _getConcreteOrRandomNumberTrivia(func);
    };

    private:
    NumberTrivia _getConcreteOrRandomNumberTrivia(std::function<NumberTriviaModel(void)> func){
        if(networkInfo->isConnected()){
            auto result = func(); 


            localDataSource->cacheNumberTrivia(result);
            return result;
        }else{
            auto cached = localDataSource->getLastNumberTrivia(); 

            return cached;
        }
    }

};