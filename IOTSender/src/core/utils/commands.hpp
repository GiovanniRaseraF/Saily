#pragma once

#include <exception>
#include <iostream>
#include <expected>

#include <boost/filesystem.hpp>
#include <boost/asio.hpp>
#include <boost/process.hpp>

#define NOW std::chrono::time_point<std::chrono::steady_clock>::clock::now()
namespace bp = boost::process;

struct TimeOutException : public std::exception {
    std::string message;
    TimeOutException(std::string s) : message{s} {}

    std::string what(){
        return message;
    }
};

namespace commands {
    std::chrono::duration<long long> MAX_DURATION = std::chrono::seconds(200);

    struct command {
        static std::string exec(std::string command, std::vector<std::string> argv, int &out_code){
            std::string ret;
            bp::ipstream out;
            bp::ipstream err;

            auto start = NOW;

            bp::child c(bp::search_path(command), argv, bp::std_out > out, bp::std_err > err);

            // read output
            for (std::string line; (NOW - start) < MAX_DURATION && c.running() && std::getline(out, line);) {
                ret+=line;
            }

            auto end = NOW;
            if((end - start) < MAX_DURATION){
                c.wait();
                int exit_code = c.exit_code();
                out_code = exit_code;
                if(exit_code != 0){
                    throw TimeOutException("TimeOut on exit code: " + std::to_string(exit_code));
                }
            }else{
                throw TimeOutException("Time out of curl subprocess");
            }

            return ret; 
        }
    };
    
    struct curl_class {
        std::string operator()(std::string site){
            int out_code = 0;

            std::string ret = command::exec("curl", {site}, out_code);

            return ret;
        }
    };

    struct ping_class {
        std::string operator()(std::string site){
            int out_code = 0;

            std::string ret = command::exec("ping", {site, "-t", "1"}, out_code);

            return ret;
        }
    };

    enum class HTTP_PROTOCOL {
        http, https 
    };

    struct curl_data_send_class {
        /// @brief send data in this format
        /// curl -X POST {protocol}://{site}/{endpoint} -d {data}
        std::expected<std::string, TimeOutException> operator()(HTTP_PROTOCOL protocol, std::string site, std::string endpoint, std::string data){
            int out_code = 0;

            std::string uri = "";
            if(protocol == HTTP_PROTOCOL::http){
                uri = "http";
            }else if(protocol == HTTP_PROTOCOL::https){
                uri = "https";
            }
            uri+=("://" + site + "/" + endpoint);
            std::vector<std::string> params = {"-X", "POST", uri, "-d", data};
            
            // debug
            // std::cout << "curl ";
            // for(auto p : params){
            //     std::cout << p << " ";
            // }
            // std::cout << std::endl;

            try{
                std::string ret = command::exec("curl", params, out_code);
                return ret;
            }catch(TimeOutException &toe){
                (void)(toe);
                return std::unexpected(toe);
            }
        }
    };

    static ping_class ping = ping_class();
    static curl_class curl = curl_class();
    static curl_data_send_class curlDataSend = curl_data_send_class();
};