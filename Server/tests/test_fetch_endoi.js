// Author: Giovanni Rasera
// arrange
const testName = "should fetch endothermic motor info";
const http = require('http');
const data = "";

const options = {
  hostname: 'localhost',
  port : 8567,
  path: '/fetch_endoi',
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
    if(
        response.motorRPM &&
        response.refrigerationTemperature &&
        response.batteryVoltage &&
        response.throttlePedalPosition && 
        response.glowStatus && 
        response.dieselStatus && 
        response.fuelLevel1 && 
        response.fuelLevel2
    ){
        console.log(" !! FAIL: response malformed " + `${responseData}`)
    }else{
        console.log("OK :) ")
    }
    }catch{
        console.log(" !! FAIL: cannot parse data " +  responseData);
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