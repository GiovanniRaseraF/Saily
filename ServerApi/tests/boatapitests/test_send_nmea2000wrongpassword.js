// Author: Giovanni Rasera
// arrange
const testName = "should respond with boat authentication error if user or password are wrong";
const env = require("./envload")
const _ = require("lodash");
const { error_boat_authentication } = require("../../api/errors");
const https = require(env.HTTP_PROTOCOL);
const data = `boat_id=0x0001&mqtt_user=wrong&mqtt_password=wrong&actual_message={"lat":11, "lng":12, "test" : "testmessage"}`;

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
const req = https.request(options, (res) => {
    let responseData = '';

    res.on('data', (chunk) => {
        responseData += chunk;
    });

    res.on('end', () => {
        try {
            const response = JSON.parse(responseData);
            if (
                _.isEqual(response,  error_boat_authentication)
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