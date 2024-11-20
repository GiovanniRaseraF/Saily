// Author: Giovanni Rasera
// arrange

const arguments = process.argv
console.log(arguments);

const routeCannes = require("./cannes.js");
const routeVenice = require("./venice.js");
const routeGeneric1 = require("./generic1.js");

const boatsList = [
    {boat_id : "0x0010", mqtt_user: "test", mqtt_password : "test", route: routeCannes},
    {boat_id : "0x0020", mqtt_user: "test", mqtt_password : "test", route: routeVenice},
    {boat_id : "0x0030", mqtt_user: "test", mqtt_password : "test", route: routeGeneric1},
];
// info print
console.log("Simulation Started");
for(let b in boatsList){
    console.log(boatsList[b].boat_id);
}

const testName = "just stress test";
const env = require("./envload")
const _ = require("lodash");
const https = require(env.HTTP_PROTOCOL);
const defaultPath = '/send_nmea2000/vtgi';

function createSend(endpoindPath, actualStr, boat_id, mqtt_user, mqtt_password) {
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


async function sim(boat){
    const route = boat.route;
    const boat_id = boat.boat_id;
    const mqtt_password= boat.mqtt_password;
    const mqtt_user= boat.mqtt_user;

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
                    let sendNmea2000 = createSend(defaultPath, actual_message_str, boat_id, mqtt_user, mqtt_password);
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
                    let send = createSend("/send_emi", responseStr, boat_id, mqtt_user, mqtt_password);
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
                    let send = createSend("/send_endoi", responseStr, boat_id, mqtt_user, mqtt_password);
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
                    let sendhpbi = createSend("/send_hpbi", responsehpbiStr, boat_id, mqtt_user, mqtt_password);

                    await sendhpbi();
                }

                const delay = ms => new Promise(resolve => setTimeout(resolve, ms))
                await delay(30000);
            }

            await f();
        }
    }
}

async function main() {
    for(let boat in boatsList){
        sim(boatsList[boat]);
    }
}

main();
