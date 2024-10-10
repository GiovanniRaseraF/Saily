const mysql = require("mysql"); 
const fs = require("fs");
const { result } = require('lodash');

module.exports = function (env){
    class mysqlDatabase{
        connect() {
            console.log(env)
        }
    }
} 