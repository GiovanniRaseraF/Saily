#pragma once
#include <string>

class NumberTrivia {
public:
    NumberTrivia() : number{0}, text{""} {}
    NumberTrivia(int n, std::string t) : number{n}, text{t} {}
    int number;
    std::string text;

    
    virtual std::string say(){
        return std::to_string(number) + " - " + text;
    }

    friend bool operator==(const NumberTrivia &lh, const NumberTrivia&rh){
        return lh.number == rh.number && lh.text == rh.text;
    }
};