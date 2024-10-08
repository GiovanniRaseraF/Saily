// Author: Giovanni Rasera
// arrange
const testName = "ping should responde with date and version";
const http = require('http');
const data = "";

const options = {
  hostname: 'localhost',
  port : 8567,
  path: '/fetchmyboats',
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
    if(true){
        console.log(" !! FAIL: response malformed " + `${responseData}`)
    }else{
        console.log("OK :) TODO: implement")
    }
    }catch{
        console.log(" !! FAIL: cannot parse data " +  responseData);
    }
    console.log("\n\n\n");
  });
});

req.on('error', (error) => {
  console.error('Error:', error);
});

// accert
console.log(testName);
req.write(data);
req.end();



