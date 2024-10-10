// Test con username giusto e password giusta

const testName = "When both user and password are correct SHOULD response with canuselogin true";
const https = require('http');

const env = require("./envload")
const data = "username=g.rasera@huracanmarine.com&password=MoroRacing2024";

const options = {
 hostname: env.HOST_NAME,
  port : env.SERVER_PORT,
  path: '/login',
  method: 'POST',
  headers: {
    'Content-Type': 'application/x-www-form-urlencoded',
    'Content-Length': data.length,
  },
};

const req = https.request(options, (res) => {
  let responseData = '';

  res.on('data', (chunk) => {
    responseData += chunk;
  });

  res.on('end', () => {
    console.log('Response:', responseData);
    if(JSON.parse(responseData).canuselogin == true){
        console.log("OK :)");
    }else{
        console.log("test: FAIL");
    }
    console.log("\n\n\n\n\n\n");
  });
});

req.on('error', (error) => {
  console.error('Error:', error);
});

console.log(testName);
req.write(data);
req.end();