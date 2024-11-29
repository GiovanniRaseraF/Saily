#pragma once
#include <gtest/gtest.h>
#include <gmock/gmock.h>
#include "features/domain/repos/number_trivia_repo.hpp"

class MockNumberTriviaRepo : public NumberTriviaRepo {
    public:
    MOCK_METHOD(NumberTrivia, getConcreteNumberTrivia, (int number), (override));
    MOCK_METHOD(NumberTrivia, getRandomNumberTrivia, (), (override));
};