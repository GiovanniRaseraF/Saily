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
require("./api/ping")                 (app)

require("./api/login")                (app, new db())
require("./api/boats")                (app, new db())

require("./api/fetch_emi")            (app, new db())
require("./api/fetch_acti")           (app, new db())
require("./api/fetch_endoi")          (app, new db())
require("./api/fetch_hpbi")           (app, new db())
require("./api/fetch_gi")             (app, new db())
require("./api/fetch_vi")             (app, new db())
require("./api/fetch_nmea2000")       (app, new db())

// list of functions for boats
require("./boatapi/send_emi")         (app, new db())
require("./boatapi/send_acti")        (app, new db())
require("./boatapi/send_endoi")       (app, new db())
require("./boatapi/send_hpbi")        (app, new db())
require("./boatapi/send_gi")          (app, new db())
require("./boatapi/send_vi")          (app, new db())
require("./boatapi/send_nmea2000")    (app, new db())

// default route
require("./api/default")              (app)

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
