#pragma once

#include <fstream>
#include <core/utils/shared_preferences.hpp>
#include <features/data/models/number_trivia_model.hpp>

struct LocalDataSource {
    public:
    /// Get the chached [NumberTriviaModel]
    ///
    /// Throws [CacheException] if no data available
    virtual NumberTriviaModel getLastNumberTrivia() = 0;

    /// Cache {triviaToCache} to the local cache
    virtual void cacheNumberTrivia(NumberTriviaModel triviaToCache) = 0;

};

const std::string LAST_CHACHED_NUMBER_TRIVIA = "LAST_CHACHED_NUMBER_TRIVIA";

struct LocalDataSourceImpl : public LocalDataSource {
    public:
    LocalDataSourceImpl(SharedPreferences &p) : prefs{p}{} 

    SharedPreferences prefs;

    virtual void cacheNumberTrivia(NumberTriviaModel triviaToCache) override {
        std::string tosave = triviaToCache.toJsonString();

        prefs.storeString(LAST_CHACHED_NUMBER_TRIVIA, tosave);
    }

    virtual NumberTriviaModel getLastNumberTrivia() override {
        std::string toparse = prefs.getString(LAST_CHACHED_NUMBER_TRIVIA);

        return NumberTriviaModel::fromJsonString(toparse);
    }

};