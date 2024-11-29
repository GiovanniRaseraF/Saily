#pragma once
#include <sstream>

#include <features/domain/entities/number_trivia.hpp>
#include <core/exceptions/exceptions.hpp>
#include <core/utils/json_parser.hpp>

class NumberTriviaModel : public NumberTrivia {
    public:
    NumberTriviaModel() {}
    NumberTriviaModel(int n, std::string t) : NumberTrivia(n, t) {}

    std::string toJsonString(){
        std::stringstream ss;

        ss << "{";
        ss << "\"number\" : " << number << ",";
        ss << "\"text\" : " << "\"" << text << "\""<< ",";
        ss << "\"found\" : true" << ",";
        ss << "\"type\" : \"trivia\"" << "";
        ss << "}";

        return ss.str();
    }

    /// @brief TODO: to implement
    /// @param json: json representation of the data
    /// @return A new NumberTriviaModel with the parsed json
    /// @throws JsonParseException if the parsing fails
    static NumberTriviaModel fromJsonString(std::string jsonstr){
        try{
            json parsed = json::parse(jsonstr);
            
            int n = std::floor((float)parsed["number"]);
            std::string t = (std::string)parsed["text"];
            
            return NumberTriviaModel(n, t);
        }catch (std::exception &e){
            throw JsonParseException();
        }
    }
};