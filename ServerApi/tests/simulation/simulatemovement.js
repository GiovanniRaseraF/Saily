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

const testName = "just stress test";
const env = require("./envload")
const _ = require("lodash");
// import the noise functions you need
const { createNoise2D } = require('simplex-noise');
// initialize the noise function
let noise2D = createNoise2D();
const { error_boat_authentication } = require("../../api/errors");
const https = require(env.HTTP_PROTOCOL);
const defaultPath = '/send_nmea2000/vtgi';

function createSend(endpoindPath, actualStr) {
    return async function send() {
        const data = `boat_id=${boat_id}&mqtt_user=${mqtt_user}&mqtt_password=${mqtt_password}&actual_message=${actualStr}`;
        //console.log(data);

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

const route = require("./cannes.js");

async function main() {
    while (true) {
        for (let i = 0; i < route.trkpt.length; i++) {
            let f = async function () {
                let pos = (route.trkpt[i]);
                let actualLat = parseFloat(pos._lat);
                let actualLng = parseFloat(pos._lon);
                {
                    let actual_message = { "satellitesCount": 1, "isFixed": false, "SOG": 2.3, "lat": actualLat, "lng": actualLng };
                    console.log(actual_message);
                    let actual_message_str = JSON.stringify(actual_message);
                    let sendNmea2000 = createSend(defaultPath, actual_message_str);
                    await sendNmea2000();
                };

                {
                    let busVoltage = 0.0;
                    let motorCurrent = 0.0;
                    let inverterTemperature = 0.0;
                    let motorTemperature = 0.0;
                    let motorRPM = 2000 + Math.random() * 1000;//Date.now();

                    let response = { busVoltage, motorCurrent, inverterTemperature, motorTemperature, motorRPM };
                    let responseStr = JSON.stringify(response);
                    let send = createSend("/send_emi", responseStr);
                    await send();
                }


                {
                    let motorRPM = 3; // RPM
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

                    let totalVoltage = 160.0;
                    let totalCurrent = 23.0;
                    let batteryTemperature = 24.0;
                    let bmsTemperature = 20.0;
                    let SOC = 23.3 + Math.random() * 20;
                    let power = 23.0 + Math.random() * 7;
                    let tte = 55;
                    let auxBatteryVoltage = 12.1;
                    let responsehpbi = { totalVoltage, totalCurrent, batteryTemperature, bmsTemperature, SOC, power, tte, auxBatteryVoltage };

                    let responsehpbiStr = JSON.stringify(responsehpbi);
                    let sendhpbi = createSend("/send_hpbi", responsehpbiStr);
                    await sendhpbi();
                }

                const delay = ms => new Promise(resolve => setTimeout(resolve, ms))
                await delay(1000);
            }

            await f();
        }
    }
}

main();
