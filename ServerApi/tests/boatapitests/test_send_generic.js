// Author: Giovanni Rasera
// arrange

const arguments = process.argv
console.log(arguments);

let boat_id         = arguments[2] == undefined ? "0x0001"  : arguments[2];
let mqtt_user       = arguments[3] == undefined ? "test"    : arguments[3];
let mqtt_password   = arguments[4] == undefined ? "test"    : arguments[4];
let username        = arguments[5] == undefined ? "g.rasera@huracanmarine.com" : arguments[5];
let password        = arguments[6] == undefined ? "MoroRacing2024" : arguments[6];

console.log({
    boat_id,
    mqtt_user,
    mqtt_password,
    username,
    password 
});

let actual_message = {"satellitesCount":1,"isFixed":false,"SOG":2.3,"lat":45.6789,"lng":Date.now()};
let actual_message_str = JSON.stringify(actual_message);

const testName = "just stress test";
const env = require("./envload")
const _ = require("lodash");
const { error_boat_authentication } = require("../../api/errors");
const https = require(env.HTTP_PROTOCOL);

async function send(){
    const data = `boat_id=${boat_id}&mqtt_user=${mqtt_user}&mqtt_password=${mqtt_password}&actual_message=${actual_message_str}`;
    console.log(data);

    const options = {
        hostname: env.HOST_NAME,
        port: env.SERVER_PORT,
        path: '/send_nmea2000/vtgi', // important to vtgi and nmea2000 prefix
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

async function fetch(){
    const data = `boat_id=${boat_id}&username=${username}&password=${password}`;
    console.log(data);

    const options = {
        hostname: env.HOST_NAME,
        port: env.SERVER_PORT,
        path: '/fetch_nmea2000/vtgi', // important to vtgi and nmea2000 prefix
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
                    _.isEqual(response, actual_message)
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

async function main(){
    await send();
    await fetch();
}

main();
