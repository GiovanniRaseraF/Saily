#pragma once
#include <gtest/gtest.h>
#include <gmock/gmock.h>

#include "features/domain/usecases/get_random_number_trivia.hpp"
#include "mock_repo.hpp"

using ::testing::Return;
TEST(UseCases, GetRandomNumberTriviaUseCase){
    //std::cout << "GerRandom" << std::endl;
    std::shared_ptr<MockNumberTriviaRepo> repo = std::make_shared<MockNumberTriviaRepo>();
    GetRandomNumberTrivia usecase(repo);
    NumberTrivia trivia(1, "test");

    ON_CALL(*repo, getRandomNumberTrivia()).WillByDefault(Return(trivia));

    EXPECT_CALL(*repo, getRandomNumberTrivia);

    auto res = usecase.call();

    EXPECT_EQ(res, trivia);
}