// Author: Giovanni Rasera and Lorenzo Mancini

// TODO: protect from sql injectio

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
            console.log(`MySql whats to connect to:\n\t${env.DATABASE_HOST}\n\t${env.DATABASE_USER}@${env.DATABASE_NAME}`)
            console.log(`Bash Script:\n\tmysql -u ${env.DATABASE_NAME} -p ${env.DATABASE_NAME}`)

            // making the actual connection
            this.pool = mysql.createConnection({
                user: env.DATABASE_USER,
                host: env.DATABASE_HOST,
                database: env.DATABASE_NAME,
                password: env.DATABASE_PASSWORD,
                multipleStatements: false
            });
        }

        // Func for hashing passwords whith SHA-256
        async hashPassword(password) {
            return await bcrypt.hash(password, saltRounds);
        }
        
        // calls the database and return [] or the actual user
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

        // get boat by id and mqtt_user and mqtt_password
        async get_boat(boat_id, mqtt_user, mqtt_password) {
            var sql = `SELECT * FROM boats WHERE boat_id = '${boat_id}' AND mqtt_user = '${mqtt_user}' AND mqtt_password = '${mqtt_password}';`;
            console.log(sql);

            this.getBoat = function (pool) {
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

            let ret = await this.getBoat(this.pool);
            //console.log(ret);
            return (ret);
        }

        async getBoatByIdAndMqttUserPass(boat_id, mqtt_user, mqtt_password) {
            let userResult;
            try {
                userResult = await this.get_boat(boat_id, mqtt_user, mqtt_password);
            } catch (err) {
                console.error(err);
                return undefined;
            }

            return userResult[0];
        }

        // is boat credential good ? 
        async isBoatCredentialGood(boat_id, mqtt_user, mqtt_password) {
            const row = await this.getBoatByIdAndMqttUserPass(boat_id, mqtt_user, mqtt_password);

            if (row === undefined) {
                return false;
            }

            return true;
        }
        
        // get the boats of a specefic user
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
            let pedal = 0; // %
            let requestedGear = 0;
            let validatedGear = 0;
            let pedalTrim = 0;

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
            let busVoltage = 0.0;
            let motorCurrent = 0.0;
            let inverterTemperature = 0.0;
            let motorTemperature = 0.0;
            let motorRPM = 0.0;

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
            let motorRPM = 0; // RPM
            let refrigerationTemperature = 0.0; // C
            let batteryVoltage = 0.0; // factor 0.1 V
            let throttlePedalPosition = 0; // %
            let glowStatus = 0; //GlowStatus.OFF
            let dieselStatus = 0; // DieselStatus.WAIT;
            let fuelLevel1 = 0; // %
            let fuelLevel2 = 0; // %

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

        async getLastBoatGeneralInfo(user_id, boat_id) {
            let isHybrid = false; // false = FullElectric , true = Hybrid
            let isDualMotor = false; // false = SingleMotor, true = DualMotor
            let versionProtocol = 0.0; // factor 0.1
            let versionFWControlUnit = 0.0; // factor 0.01
            let versionFWDrive = 0.0; // factor 0.01
            let dieselMotorModel = 0; // DieselMotorModel.None; // Tabella 1
            let electricMotorModel = 0; //ElectricMotorModel.None; // Tabella 2

            const response = {
                isHybrid,
                isDualMotor,
                versionProtocol,
                versionFWControlUnit,
                versionFWDrive,
                dieselMotorModel,
                electricMotorModel
            };

            return response;
        }

        async getLastBoatNMEA2000VTGInfo(user_id, boat_id) {
            let satellitesCount = 0;
            let isFixed = false;
            let SOG = 0; // usualy in km/hr from NMEA2000
            let lat = 45.432453; // fake position near Venice
            let lng = 12.328085;

            const response = {
                satellitesCount,
                isFixed,
                SOG,
                lat,
                lng
            };

            return response;
        }

        async getLastBoatVehicleInfo(user_id, boat_id) {
            let vehicleStatus = 0; //VehicleStatus.WAIT;
            let isHybrid = false;
            let isElectric = false;
            let isDiesel = false;
            let isSeaWaterPressureOK = false;
            let isGlicolePressureOK = false;
            let isLowSocLevel = false;
            let sealINTemperature = 0.0; // C
            let sealOUTTemperature = 0.0; // C
            let glicoleINTemperature = 0.0; // C
            let glicoleOUTTemperature = 0.0; // C
            let isECUOn = false;
            let isDCUOn = false;
            let voltageToECU = 0.0; // factor 0.1 V

            let timecounter = 0; //min
            let timecounterElectricMotor = 0; //min
            let timecounterDieselMotor = 0; //min 

            const response = {
                vehicleStatus,
                isHybrid,
                isElectric,
                isDiesel,
                isSeaWaterPressureOK,
                isGlicolePressureOK,
                isLowSocLevel,
                sealINTemperature,
                sealOUTTemperature,
                glicoleINTemperature,
                glicoleOUTTemperature,
                isECUOn,
                isDCUOn,
                voltageToECU,
                timecounter,
                timecounterElectricMotor,
                timecounterDieselMotor
            };

            return response;
        }


        // Send boat info
        async send_info(boat_id, mqtt_user, mqtt_password, actual_message, database_table_name) {
            var sql = "";//`SELECT * FROM ${database_table_name} WHERE user_email = '${username}';`;

            this.sendInfo = function (pool) {
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

            let ret = await this.sendInfo(this.pool);
            return (ret);
        }

        async sendLastBoatNMEA2000VTGInfo(boat_id, mqtt_user, mqtt_password, actual_message) {
            console.log("FromDatabase:");
            console.log(mqtt_user);
            console.log(mqtt_password);
            console.log(boat_id);
            console.log(actual_message);

            // TODO: Check for boat info credential then send to database the new data

            const response = {};
            return response;
        }
    }
}