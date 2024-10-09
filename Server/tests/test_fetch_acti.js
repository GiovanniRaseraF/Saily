// Author: Giovanni Rasera
// arrange
const testName = "should fetch actuator info";
const http = require('http');
const data = "";

const options = {
    hostname: 'localhost',
    port: 8567,
    path: '/fetch_acti',
    method: 'POST',
    headers: {
        'Content-Type': '',
        'Content-Length': data.length,
    },
};

// act
const req = http.request(options, (res) => {
    let responseData = '';

    res.on('data', (chunk) => {
        responseData += chunk;
    });

    res.on('end', () => {
        try {
            const response = JSON.parse(responseData);
            if (
                response.pedal != undefined &&
                response.requestedGear != undefined &&
                response.validatedGear != undefined &&
                response.pedalTrim != undefined
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