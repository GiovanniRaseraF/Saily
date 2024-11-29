#pragma once
#include <vector>
#include <string>
#include <cstdio>
#include <iostream>
#include <memory>
#include <stdexcept>
#include <array>

// from internet
static std::string exec(const char* cmd) {
    std::array<char, 128> buffer;
    std::string result;
    std::unique_ptr<FILE, decltype(&pclose)> pipe(popen(cmd, "r"), pclose);

    if (!pipe) {
        throw std::runtime_error("popen() failed!");
    }
    while (fgets(buffer.data(), buffer.size(), pipe.get()) != nullptr) {
        result += buffer.data();
    }

    return result;
} 

class ConnectionTester {
    public:
    ConnectionTester(){}
    ~ConnectionTester(){}

    std::vector<std::string> sites = {
        "www.google.com",
        "www.google.it",
        "1.1.1.1",
        "8.8.8.8",
    };

    virtual bool checkInternetConnection(){
        for(auto s : sites){
            // ping site

            // TODO: add Windows Support
            std::string command = "ping " + s + " -c 1 2> /dev/null";
            try{
                auto res = exec(command.c_str());

                if(res != "") return true;
            }catch (std::runtime_error &re){
                std::cerr << re.what() << std::endl;
                return false;
            }
        }
        return false;
    }   
};

class NetworkInfo {
    public:
    NetworkInfo(std::shared_ptr<ConnectionTester> ct) : connectionTester{ct} {};
    std::shared_ptr<ConnectionTester> connectionTester;

    bool isConnected(){
        return connectionTester->checkInternetConnection();
    }
};