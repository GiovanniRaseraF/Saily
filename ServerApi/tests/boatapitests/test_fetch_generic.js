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

const errors = require("../../api/errors");
const testName = "just stress test";
const env = require("./envload")
const _ = require("lodash");
const https = require(env.HTTP_PROTOCOL);
const defaultPath = '/fetch_nmea2000/vtgi';

function createSend(endpoindPath) {
    return async function send() {
        const data = `boat_id=${boat_id}&mqtt_user=${mqtt_user}&mqtt_password=${mqtt_password}&username=${username}&password=${password}`;
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
                    //console.log(response);
                    if (
                        ! _.isEqual(response, errors.error_boat_authentication) 
                        && ! _.isEqual(response, errors.error_authentication)
                        && ! _.isEqual(response,{})
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
        let sendNmea2000 = createSend(defaultPath);
        await sendNmea2000();
    }

    {
        let sendhpbi = createSend("/fetch_hpbi");
        await sendhpbi();
    }

    {
        let sendvi = createSend("/fetch_vi");
        await sendvi();
    }

    {
        let send = createSend("/fetch_gi");
        await send();
    }

    {
        let send = createSend("/fetch_endoi");
        await send();
    }

    {
        let send = createSend("/fetch_emi");
        await send();
    }

    {
        let send = createSend("/fetch_acti");
        await send();
    }
}

main();
