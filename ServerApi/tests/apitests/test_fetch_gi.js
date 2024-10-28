// Author: Giovanni Rasera
// arrange
const testName = "should fetch general info";
const env = require("./envload")
const https = require(env.HTTP_PROTOCOL);
const data = "boat_id=0x0&username=g.rasera@huracanmarine.com&password=MoroRacing2024";

const options = {
  hostname: env.HOST_NAME,
  port : env.SERVER_PORT,
  path: '/fetch_gi',
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
    if(
        response.isHybrid != undefined &&
        response.isDualMotor != undefined &&
        response.versionProtocol != undefined &&
        response.versionFWControlUnit != undefined &&
        response.versionFWDrive != undefined &&
        response.dieselMotorModel != undefined &&
        response.electricMotorModel != undefined
    ){
        console.log("OK :) " + `${responseData}`)
    }else{
        console.log(" !! FAIL: response malformed " + `${responseData}`)
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