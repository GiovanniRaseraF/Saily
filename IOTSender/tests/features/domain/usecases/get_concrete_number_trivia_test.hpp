#pragma once
#include <gtest/gtest.h>
#include <gmock/gmock.h>

#include "features/domain/usecases/get_concrete_number_trivia.hpp"
#include "mock_repo.hpp"

using ::testing::Return;
TEST(UseCases, GetConcreteNumberTriviaUseCase){
    std::shared_ptr<MockNumberTriviaRepo> repo = std::make_shared<MockNumberTriviaRepo>();
    GetConcreteNumberTrivia usecase(repo);
    int number = 1;
    NumberTrivia trivia(number, "test");

    ON_CALL(*repo, getConcreteNumberTrivia(number)).WillByDefault(Return(trivia));

    EXPECT_CALL(*repo, getConcreteNumberTrivia(number));

    auto res = usecase.call(number);

    EXPECT_EQ(res, trivia);
}
