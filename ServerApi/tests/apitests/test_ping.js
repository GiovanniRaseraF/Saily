// Author: Giovanni Rasera
// arrange
const testName = "ping should responde with date and version";
const env = require("./envload")
const https = require(env.HTTP_PROTOCOL);
const data = "";

const options = {
  hostname: env.HOST_NAME,
  port: env.SERVER_PORT,
  path: '/ping',
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
      if (response.date == undefined || response.version == undefined) {
        console.log(" !! FAIL: response malformed " + `${responseData}`)
      } else {
        console.log("OK :)" + `${responseData}`)
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



