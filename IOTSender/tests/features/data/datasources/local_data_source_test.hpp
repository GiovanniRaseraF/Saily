#pragma once
#include <gtest/gtest.h>
#include <gmock/gmock.h>

#include <features/data/datasources/local_data_source.hpp>

TEST(LocalDataSource, ShouldReadTheWriteData){
    SharedPreferences p("local_prefs.db");
    LocalDataSourceImpl lds(p);

    NumberTriviaModel nt(10, "local data source");

    lds.cacheNumberTrivia(nt);
    auto ret = lds.getLastNumberTrivia();

    EXPECT_EQ(nt, ret);
}
