// Test con username sbagliato,
//  controllare che nel server non crashi !!
const testName = "When user is wrong and password is correct SHOULD response with canuselogin false";
const env = require("./envload")
const https = require(env.HTTP_PROTOCOL);

const data = "username=g.rasera&password=MoroRacing2024";

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
    if(JSON.parse(responseData).code == 0){
        console.log("OK :)");
    }else{
        console.log(" FAIL");
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