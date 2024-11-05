// Author: Giovanni Rasera and Lorenzo Mancini

// TODO: protect from sql injectio

const mysql = require("mysql");
const fs = require("fs");
const _ = require('lodash');
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

        // get boats from name
        async getBoatsFromUsername(username) {
            let boatsResult;
            try {
                boatsResult = await this.get_boats(user_id);
            } catch (err) {
                console.error(err);
                return undefined;
            }
            return boatsResult;
        }

        // Boat Info getters
        
        // get boat info
        // returns undefined if the boat_id does not belog to the user
        // returns the last value of [] if the boat_id and the user_id are valid
        async get_last_boat_info(database_table_name, user_id, boat_id) {
            // check if you can read the boat
            const boatsResult = await database.getBoatsFromId(user_id);
            const boats = _.map(boatsResult, function (b){return b.boat_id;});
            //console.log(boats);
            if(! boats.includes(boat_id)) return undefined;

            let sql = `SELECT json_value FROM ${database_table_name}
                            WHERE boats_boat_id = "${boat_id}" AND
                                id = (SELECT max(id) FROM ${database_table_name}
                                        WHERE boats_boat_id = "${boat_id}"
                                        GROUP BY boats_boat_id
                                    );`;
            
            // console.log(sql);
            this.getLastBoatInfo = function (pool) {
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
            
            try{
                let ret = await this.getLastBoatInfo(this.pool);
                return ret;
            }catch(err){
                console.log(err);
                return [];
            }
        }

        async getLastBoatHighPowerBatteryInfo(user_id, boat_id) {
            let totalVoltage = 0.0;
            let totalCurrent = 0.0;
            let batteryTemperature = 0.0;
            let bmsTemperature = 0.0;
            let SOC = 0.0;
            let power = 0.0;
            let tte = 0;
            let auxBatteryVoltage = 0.0;

            let response = {
                totalVoltage,
                totalCurrent,
                batteryTemperature,
                bmsTemperature,
                SOC,
                power,
                tte,
                auxBatteryVoltage
            };

            // TODO: test this functionality
            try{
                const values = await this.get_last_boat_info("high_power_battery_info", user_id, boat_id);
                if(values == undefined) return undefined;
                if(values.length == 0) return response;

                const latest = values[0];
                response = JSON.parse(latest.json_value);
            }catch(err){
                console.log(err);
                return undefined;
            }

            return response;
        }

        async getLastBoatActuatorInfo(user_id, boat_id) {
            let pedal = 0; // %
            let requestedGear = 0;
            let validatedGear = 0;
            let pedalTrim = 0;

            // TODO: Implement fetch from redis or a realtime database

            let response = {
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

            let response = {
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

            let response = {
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

            let response = {
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
            let lat = 0; // fake position near Venice
            let lng = 0;

            let response = {
                satellitesCount,
                isFixed,
                SOG,
                lat,
                lng
            };
            
            // TODO: test this functionality
            try{
                const values = await this.get_last_boat_info("nmea2000_vtg_info", user_id, boat_id);
                if(values == undefined) return undefined;
                if(values.length == 0) return response;

                const latest = values[0];
                response = JSON.parse(latest.json_value);
            }catch(err){
                console.log(err);
                return undefined;
            }

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

            let response = {
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

            // TODO: test this functionality
            try{
                const values = await this.get_last_boat_info("vehicle_info", user_id, boat_id);
                if(values == undefined) return undefined;
                if(values.length == 0) return response;

                const latest = values[0];
                response = JSON.parse(latest.json_value);
            }catch(err){
                console.log(err);
                return undefined;
            }

            return response;
        }


        // Send boat info
        async insert_boat_info(database_table_name, boat_id, mqtt_user, mqtt_password, json_value) {
            let goodCredentials = await this.isBoatCredentialGood(boat_id, mqtt_user, mqtt_password);
            if (!goodCredentials) { return false; }

            let jsonEnc = JSON.parse(json_value);
            let jsonStr = JSON.stringify(jsonEnc);

            let sql = `INSERT INTO ${database_table_name} (json_value, timestamp, boats_boat_id) 
                        VALUES
                            ('${jsonStr}', now(), '${boat_id}');`;

            //console.log(sql);
            this.insertBoatInfo = function (pool) {
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
            try{
                let ret = await this.insertBoatInfo(this.pool);
                return true;
            }catch(err){
                console.log(err);
                return false;
            }
        }

        // sends the nemea data to the database and to redis database
        // TODO: implement redis database store
        async sendLastBoatNMEA2000VTGInfo(boat_id, mqtt_user, mqtt_password, actual_message) {
            return await this.insert_boat_info("nmea2000_vtg_info", boat_id, mqtt_user, mqtt_password, actual_message);
        }

        // TODO: implement redis database store
        async sendLastBoatHighPowerBatteryInfo(boat_id, mqtt_user, mqtt_password, actual_message) {
            return await this.insert_boat_info("high_power_battery_info", boat_id, mqtt_user, mqtt_password, actual_message);
        }

        async sendLastBoatVehicleInfo(boat_id, mqtt_user, mqtt_password, actual_message) {
            return await this.insert_boat_info("vehicle_info", boat_id, mqtt_user, mqtt_password, actual_message);
        }
        
        async sendLastBoatGeneralInfo(boat_id, mqtt_user, mqtt_password, actual_message) {
            return await this.insert_boat_info("general_info", boat_id, mqtt_user, mqtt_password, actual_message);
        }
        
        async sendLastBoatEndothermicMotorInfo(boat_id, mqtt_user, mqtt_password, actual_message) {
            return await this.insert_boat_info("endothermic_motor_info", boat_id, mqtt_user, mqtt_password, actual_message);
        }

        async sendLastBoatElectricMotorInfo(boat_id, mqtt_user, mqtt_password, actual_message) {
            return await this.insert_boat_info("electric_motor_info", boat_id, mqtt_user, mqtt_password, actual_message);
        }

        async sendLastBoatActuatorInfo(boat_id, mqtt_user, mqtt_password, actual_message) {
            return await this.insert_boat_info("actuator_info", boat_id, mqtt_user, mqtt_password, actual_message);
        }
    }
}