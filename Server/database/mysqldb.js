// Author: Giovanni Rasera and Lorenzo Mancini

const mysql = require("mysql");
const fs = require("fs");
const result = require('lodash');
const bcrypt = require("bcrypt")

const saltRounds = 10;

module.exports = function (env) {
    // here we return the class from the function
    // this class contains the environment
    return class mysqlDatabase {
        connect() {
            console.log(`MySql whats to connect to:\n\t${env.DATABASE_HOST}\n\t${env.DATABASE_USER}`)

            // making the actual connection
            this.pool = mysql.createConnection({
                user: env.DATABASE_USER,
                host: env.DATABASE_HOST,
                database: env.DATABASE_NAME,
                password: env.DATABASE_PASSWORD
            });
        }

        // Func for hashing passwords whith SHA-256
        async hashPassword(password) {
            return await bcrypt.hash(password, saltRounds);
        }

        async get_account(username, password) {
            var sql = `SELECT * FROM user_account WHERE user_email = '${username}';`;
            //console.log(sql);

            this.getAccount = function (pool) {
                return new Promise(function (resolve, reject) {
                    pool.query(
                        sql,
                        function (err, rows) {
                            if (rows === undefined) {
                                resolve([]);
                            } else {
                                resolve(rows);
                            }
                        }
                    )
                }
                )
            }

            let ret = await this.getAccount(this.pool);
            //console.log(ret);
            return (ret);
        }

        async get_boats(user_id) {

            var sql = `SELECT * FROM boats WHERE user_id = '${user_id}';`;

            this.getBoats = function (pool) {
                return new Promise(function (resolve, reject) {
                    pool.query(
                        sql,
                        function (err, rows) {
                            if (rows === undefined) {
                                resolve([]);
                            } else {
                                resolve(rows);
                            }
                        }
                    )
                }
                )
            }

            let ret = await this.getBoats(this.pool);

            //console.log(ret);
            return (ret);
        }


        // this function return an object
        // { user_id: , user_email: , password_hash: }
        async getUserByNameAndPassword(username, password) {
            let userResult;
            // controllo la presenza
            try {
                // Verifica delle credenziali dell'utente
                userResult = await this.get_account(username, password);
            } catch (err) {
                console.error(err);
                return undefined;
            }
            try {
                if (userResult.length === 0) {
                    return undefined;
                }
                const userPassword = userResult[0].password_hash;
                const passwordMatch = await bcrypt.compare(password, userPassword);
                if (!passwordMatch) {
                    return undefined;
                }
            } catch (err) {
                console.error(err);
                return undefined;
            }

            return userResult[0];
        }

        // is user in DB
        async isUserInDb(username, password) {
            const row = await this.getUserByNameAndPassword(username, password);

            if (row === undefined) {
                return false;
            }

            return true;
        }

        // get boats from id
        async getBoatsFromId(user_id) {
            let boatsResult;
            try {
                // Recupera la lista di barche associate all'utente
                boatsResult = await this.get_boats(user_id);
            } catch (err) {
                console.error(err);
                return undefined;
            }
            return boatsResult;
        }

        // Boat Info getters
        async getLastBoatHighPowerBatteryInfo(user_id, boat_id) {
            let totalVoltage = 0.0;
            let totalCurrent = 0.0;
            let batteryTemperature = 0.0;
            let bmsTemperature = 0.0;
            let SOC = 0.0;
            let power = 0.0;
            let tte = 0;
            let auxBatteryVoltage = 0.0;

            // TODO: Implement fetch from redis or a realtime database

            const response = {
                totalVoltage,
                totalCurrent,
                batteryTemperature,
                bmsTemperature,
                SOC,
                power,
                tte,
                auxBatteryVoltage
            };

            return response;
        }

        async getLastBoatActuatorInfo(user_id, boat_id) {
            const pedal = 0; // %
            const requestedGear = 0;
            const validatedGear = 0;
            const pedalTrim = 0;

            // TODO: Implement fetch from redis or a realtime database

            const response = {
                pedal,
                requestedGear,
                validatedGear,
                pedalTrim
            };

            return response;
        }


        async getLastBoatElectricMotorInfo(user_id, boat_id) {
            const busVoltage = 0.0;
            const motorCurrent = 0.0;
            const inverterTemperature = 0.0;
            const motorTemperature = 0.0;
            const motorRPM = 0.0;

            const response = {
                busVoltage,
                motorCurrent,
                inverterTemperature,
                motorTemperature,
                motorRPM
            };

            return response;
        }

        async getLastBoatEndothermicMotorInfo(user_id, boat_id) {
            const motorRPM = 0; // RPM
            const refrigerationTemperature = 0.0; // C
            const batteryVoltage = 0.0; // factor 0.1 V
            const throttlePedalPosition = 0; // %
            const glowStatus = 0; //GlowStatus.OFF
            const dieselStatus = 0; // DieselStatus.WAIT;
            const fuelLevel1 = 0; // %
            const fuelLevel2 = 0; // %

            const response = {
                motorRPM,
                refrigerationTemperature,
                batteryVoltage,
                throttlePedalPosition,
                glowStatus,
                dieselStatus,
                fuelLevel1,
                fuelLevel2
            };

            return response;
        }
    }
}