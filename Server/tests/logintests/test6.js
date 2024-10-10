// Test con username giusto e password sbagliata
const testName = "When user is correct and password is wrong SHOULD response with canuselogin false";
const https = require('http');

const env = require("./envload")
const data = "username=g.rasera@huracanmarine.com&password=Sbagliata";

const options = {
  hostname: env.HOST_NAME,
  port : env.SERVER_PORT,
  path: '/boats',
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
    if(JSON.parse(responseData).code == 0){
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