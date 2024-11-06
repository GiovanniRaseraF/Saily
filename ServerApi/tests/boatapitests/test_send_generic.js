// Author: Giovanni Rasera
// arrange

const arguments = process.argv
console.log(arguments);

let boat_id = arguments[2] == undefined ? "0x0010" : arguments[2];
let mqtt_user = arguments[3] == undefined ? "test" : arguments[3];
let mqtt_password = arguments[4] == undefined ? "test" : arguments[4];
let username = arguments[5] == undefined ? "g.rasera@huracanmarine.com" : arguments[5];
let password = arguments[6] == undefined ? "MoroRacing2024" : arguments[6];

console.log({
    boat_id,
    mqtt_user,
    mqtt_password,
    username,
    password
});

let actual_message = { "satellitesCount": 1, "isFixed": false, "SOG": 2.3, "lat": 45.6789, "lng": Date.now() };
let actual_message_str = JSON.stringify(actual_message);

const testName = "just stress test";
const env = require("./envload")
const _ = require("lodash");
const { error_boat_authentication } = require("../../api/errors");
const https = require(env.HTTP_PROTOCOL);
const defaultPath = '/send_nmea2000/vtgi';

function createSend(endpoindPath, actualStr) {
    return async function send() {
        const data = `boat_id=${boat_id}&mqtt_user=${mqtt_user}&mqtt_password=${mqtt_password}&actual_message=${actualStr}`;
        console.log(data);

        const options = {
            hostname: env.HOST_NAME,
            port: env.SERVER_PORT,
            path: endpoindPath, // important to vtgi and nmea2000 prefix
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
                'Content-Length': data.length,
            },
        };

        // act
        const req = https.request(options, async (res) => {
            let responseData = '';

            res.on('data', (chunk) => {
                responseData += chunk;
            });

            res.on('end', () => {
                try {
                    const response = JSON.parse(responseData);
                    if (
                        _.isEqual(response, {})
                    ) {
                        console.log("OK :) " + `${responseData}`)
                    } else {
                        console.log(" !! FAIL: response malformed " + `${responseData}`)
                    }
                } catch {
                    console.log(" !! FAIL: cannot parse data " + responseData);
                }
                console.log("\n");
            });
        });

        req.on('error', (error) => {
            console.error('Error:', error);
        });

        // accert
        console.log(testName);
        req.write(data);
        req.end();
    }
}

async function main() {
    {
        let sendNmea2000 = createSend(defaultPath, actual_message_str);
        await sendNmea2000();
    }

    {
        let totalVoltage = 0.0;
        let totalCurrent = 0.0;
        let batteryTemperature = 0.0;
        let bmsTemperature = 0.0;
        let SOC = 0.0;
        let power = 0.0;
        let tte = 0;
        let auxBatteryVoltage = Date.now();
        let responsehpbi = { totalVoltage, totalCurrent, batteryTemperature, bmsTemperature, SOC, power, tte, auxBatteryVoltage };

        let responsehpbiStr = JSON.stringify(responsehpbi);
        let sendhpbi = createSend("/send_hpbi", responsehpbiStr);
        await sendhpbi();
    }

    {
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
        let timecounterDieselMotor = Date.now(); //min 

        let responsevi = {
            vehicleStatus, isHybrid, isElectric, isDiesel, isSeaWaterPressureOK, isGlicolePressureOK, isLowSocLevel, sealINTemperature, sealOUTTemperature, glicoleINTemperature, glicoleOUTTemperature, isECUOn, isDCUOn, voltageToECU, timecounter, timecounterElectricMotor, timecounterDieselMotor
        };
        let responseviStr = JSON.stringify(responsevi);
        let sendvi = createSend("/send_vi", responseviStr);
        await sendvi();
    }

    {
        let isHybrid = false; // false = FullElectric , true = Hybrid
        let isDualMotor = false; // false = SingleMotor, true = DualMotor
        let versionProtocol = Date.now(); // factor 0.1
        let versionFWControlUnit = 0.0; // factor 0.01
        let versionFWDrive = 0.0; // factor 0.01
        let dieselMotorModel = 0; // DieselMotorModel.None; // Tabella 1
        let electricMotorModel = 0; //ElectricMotorModel.None; // Tabella 2

        let response = { isHybrid, isDualMotor, versionProtocol, versionFWControlUnit, versionFWDrive, dieselMotorModel, electricMotorModel };
        let responseStr = JSON.stringify(response);
        let send = createSend("/send_gi", responseStr);
        await send();
    }

    {
        let motorRPM = 0; // RPM
        let refrigerationTemperature = 0.0; // C
        let batteryVoltage = 0.0; // factor 0.1 V
        let throttlePedalPosition = 0; // %
        let glowStatus = 0; //GlowStatus.OFF
        let dieselStatus = 0; // DieselStatus.WAIT;
        let fuelLevel1 = 0; // %
        let fuelLevel2 = Date.now(); // %

        let response = { motorRPM, refrigerationTemperature, batteryVoltage, throttlePedalPosition, glowStatus, dieselStatus, fuelLevel1, fuelLevel2 };
        let responseStr = JSON.stringify(response);
        let send = createSend("/send_endoi", responseStr);
        await send();
    }

    {
        let busVoltage = 0.0;
        let motorCurrent = 0.0;
        let inverterTemperature = 0.0;
        let motorTemperature = 0.0;
        let motorRPM = Date.now();

        let response = { busVoltage, motorCurrent, inverterTemperature, motorTemperature, motorRPM };
        let responseStr = JSON.stringify(response);
        let send = createSend("/send_emi", responseStr);
        await send();
    }

    {
        let pedal = 0; // %
        let requestedGear = 0;
        let validatedGear = 0;
        let pedalTrim = Date.now();

        let response = { pedal, requestedGear, validatedGear, pedalTrim };
        let responseStr = JSON.stringify(response);
        let send = createSend("/send_acti", responseStr);
        await send();
    }
}

main();
