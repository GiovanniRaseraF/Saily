#pragma once
#include "features/domain/repos/number_trivia_repo.hpp"

class GetRandomNumberTrivia {
    public:
    GetRandomNumberTrivia(std::shared_ptr<NumberTriviaRepo> r) : repo{r}{}

    std::shared_ptr<NumberTriviaRepo> repo;

    virtual NumberTrivia call(){
        auto ret = repo->getRandomNumberTrivia();

        return ret;
    }
};