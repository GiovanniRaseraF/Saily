// Author: Giovanni Rasera
// arrange
const testName = "should fetch endothermic motor info";
const env = require("./envload")
const https = require(env.HTTP_PROTOCOL);
const data = "boat_id=0x0020&username=g.rasera@huracanmarine.com&password=MoroRacing2024";

const options = {
  hostname: env.HOST_NAME,
  port: env.SERVER_PORT,
  path: '/fetch_endoi',
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
        response.motorRPM != undefined &&
        response.refrigerationTemperature != undefined &&
        response.batteryVoltage != undefined &&
        response.throttlePedalPosition != undefined &&
        response.glowStatus != undefined &&
        response.dieselStatus != undefined &&
        response.fuelLevel1 != undefined &&
        response.fuelLevel2 != undefined
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