// Author: Giovanni Rasera and Lorenzo Mancini

// This server is designed to handle fetching 
// requests form Saily Application

const express = require('express')
const path = require('path')
const bodyParser = require('body-parser');
const env = require("./envload")
const db = require("./database/mysqldb")(env)
const https = require("http")

// Server
const app = express()
app.use(bodyParser.urlencoded({ extended: false }));

const port = env.SERVER_PORT

// Database
database = new db();
database.connect();

// list of fuctions
require("./api/ping")(app)

require("./api/login")(app, database)
require("./api/boats")(app, database)

require("./api/fetch_emi")(app, database)
require("./api/fetch_acti")(app, database)
require("./api/fetch_endoi")(app, database)
require("./api/fetch_hpbi")(app, database)
require("./api/fetch_gi")(app, database)
require("./api/fetch_vi")(app, database)
require("./api/fetch_nmea2000")(app, database)

// list of functions for boats
require("./boatapi/send_nmea2000")(app, database)

// default route
require("./api/default")(app)

// Available apis
console.log("Saily Apis:")
app._router.stack.forEach(r => {
  if(r.route != undefined){
    console.log("\t"+r.route.path)}
});

// Start Listening
// HTTP or HTTPS
https.createServer(app).listen(port, () => {
  console.log("Server in port: " + port);
});
