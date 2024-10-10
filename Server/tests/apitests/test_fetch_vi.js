// Author: Giovanni Rasera
// arrange
const testName = "should fetch vehicle info";
const http = require('http');
const data = "";

const env = require("./envload")

const options = {
  hostname: 'localhost',
  port: env.SERVER_PORT,
  path: '/fetch_vi',
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
        response.vehicleStatus != undefined &&
        response.isHybrid != undefined &&
        response.isElectric != undefined &&
        response.isDiesel != undefined &&
        response.isSeaWaterPressureOK != undefined &&
        response.isGlicolePressureOK != undefined &&
        response.isLowSocLevel != undefined &&
        response.sealINTemperature != undefined &&
        response.sealOUTTemperature != undefined &&
        response.glicoleINTemperature != undefined &&
        response.glicoleOUTTemperature != undefined &&
        response.isECUOn != undefined &&
        response.isDCUOn != undefined &&
        response.voltageToECU != undefined &&
        response.timecounter != undefined &&
        response.timecounterElectricMotor != undefined &&
        response.timecounterDieselMotor != undefined
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