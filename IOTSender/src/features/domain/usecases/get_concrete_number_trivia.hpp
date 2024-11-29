
#pragma once
#include <memory>
#include "features/domain/repos/number_trivia_repo.hpp"

class GetConcreteNumberTrivia {
    public:
    GetConcreteNumberTrivia(std::shared_ptr<NumberTriviaRepo> r) : repo{r}{}

    std::shared_ptr<NumberTriviaRepo> repo;

    virtual NumberTrivia call(int number){
        auto ret = repo->getConcreteNumberTrivia(number);

        return ret;
    }
};