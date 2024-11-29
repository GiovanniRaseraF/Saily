#pragma once
#include <future>
#include <thread>
#include <string>
#include <variant>
#include "features/domain/entities/number_trivia.hpp"

struct NumberTriviaRepo{
    virtual ~NumberTriviaRepo(){}
    virtual NumberTrivia getConcreteNumberTrivia(int number) = 0;
    virtual NumberTrivia getRandomNumberTrivia() = 0;
};