#pragma once

#include <string>
#include <sstream>
#include <iostream>
#include <exception>
#include <thread>
#include <queue>

#include <boost/algorithm/string.hpp>

#include <buildsqlite/sqlite3.h>

class SharedPreferenceException : public std::exception {};

std::queue<std::string> q_out;

int callback(void *NotUsed, int argc, char **argv, char **azColName) {
    int i;

    for(i = 0; i<argc; i++) {
        q_out.push(std::string(argv[i]));
    }

    return 0;
}

struct SharedPreferences {
    static bool log;

    SharedPreferences(){
        SharedPreferences("shared_preferences.db");
    }

    SharedPreferences(std::string filename){
        char *zErrMsg = 0;
        std::stringstream ss;

        auto rc = sqlite3_open(filename.c_str(), &sq);

        if( rc ) {
            ss << "Cannot open database: " << sqlite3_errmsg(sq);
        } else {
            ss << "Opened database: " << filename;
        }

        LOG(ss.str());
    }

    ~SharedPreferences(){
        sqlite3_close(sq);
        sq = nullptr;
    }


    /// @brief Store a value as int
    /// @param name of the parameter
    /// @param value to store
    /// @throws SharedPreferencesException() 
    void storeInt(std::string name, int value){
       _setX<int>(name, value, "int", [&](int toconvert){
        return std::to_string(toconvert);
       });
    }

    /// @brief Get stored value as int
    /// @param name of the stored parameter
    /// @return value stored
    /// @throws SharedPreferencesException() if the paramenter does not exist
    int getInt(std::string name){
        return _getX<int>(name, [&](std::string toconvert){
            return atoi(toconvert.c_str());
        });
    }

    /// @brief Store a value as string
    /// @param name of the parameter
    /// @param value to store
    /// @throws SharedPreferencesException()    
    void storeString(std::string name, std::string value){
       std::string purified = value;

       boost::replace_all(purified, "'", "''");

       _setX<std::string>(name, purified, "text", [&](std::string raw){
            return "'" + purified + "'";
       });
    }
    
    /// @brief Get stored value as string
    /// @param name of the stored parameter
    /// @return value stored
    /// @throws SharedPreferencesException() if the paramenter does not exist
    std::string getString(std::string name){
        return _getX<std::string>(name, [&](std::string toconvert){
            return toconvert;
        });
    }

    // attributes
    sqlite3 *sq;

    private:
    const int id_for_all = 1;

    // static
    static inline void LOG(std::string m, bool e){
        if(SharedPreferences::log){
            std::cout << m << (e ? "\n" : "");
        }
    }

    static void LOG(std::string m){
        LOG(m, true);
    }

    static void LOG(int v, bool e){
        LOG(std::to_string(v), e);
    }

    static void LOG(int v){
        LOG(std::to_string(v), true);
    }

    private:
    template <typename T>
    void _setX(std::string name, T value, std::string type, const std::function<std::string(T)> &to_savable){
        std::stringstream sql;
        std::stringstream sql_insert;
        std::stringstream sql_update;
        std::stringstream sql_droptable;
        char *zErrMsg = 0;

        sql << "create table " << name << " (id int, value " << type << " );";
        sql_insert << "insert into " << name << " (id, value) values (" << id_for_all << "," << to_savable(value) << ");";
        sql_update << "update " << name << " set value = "<< to_savable(value) << " where id = 1;";
        sql_droptable << "drop table if exists " << name << " ;";

        auto rc = sqlite3_exec(sq, sql.str().c_str(), callback, 0, &zErrMsg);

        if(rc == SQLITE_OK){
            // Can execute for the first time need to insert value
            auto rc_insert = sqlite3_exec(sq, sql_insert.str().c_str(), callback, 0, &zErrMsg);

            if(rc_insert == SQLITE_OK){
                // ok now the table was created
                LOG("OK:", false); LOG(sql_insert.str());
            }else{
                sqlite3_exec(sq, sql_droptable.str().c_str(), callback, 0, &zErrMsg);
                
                LOG("ERROR: cannot insert");
                throw SharedPreferenceException();
            }
        }else{
            // cannot create table just update
            auto rc_update= sqlite3_exec(sq, sql_update.str().c_str(), callback, 0, &zErrMsg);

            if(rc_update == SQLITE_OK){
                LOG("OK:", false); LOG(sql_update.str());
            }else{
                sqlite3_exec(sq, sql_droptable.str().c_str(), callback, 0, &zErrMsg);

                LOG("ERROR: cannot update");
                throw SharedPreferenceException();
            }
        }
        delete zErrMsg;
    }

    template<typename T>
    T _getX(std::string name, const std::function <T (std::string)>& converter){
        T value;
        std::stringstream sql;
        char *zErrMsg = 0;

        sql << "select value from " << name << " where id = 1;";

        auto read_value = [&](void *NotUsed, int argc, char **argv, char **azColName) {

        };
        auto rc = sqlite3_exec(sq, sql.str().c_str(), callback, 0, &zErrMsg);

        if(rc == SQLITE_OK){
            std::this_thread::sleep_for(std::chrono::duration(std::chrono::microseconds(1)));

            value = converter(q_out.front());
            q_out.pop();

        }else{
            LOG("ERROR: ", false);LOG(rc);
            throw SharedPreferenceException();
        }

        return value;
    }
};

// activate logging
bool SharedPreferences::log = false;

