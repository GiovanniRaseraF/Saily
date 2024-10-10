// Author: Giovanni Rasera

// This server is designed to handle fetching 
// requests form Saily Application

const express = require('express')
const path = require('path')
const env = require("./envload")
const database = require("./database/mysqldb")(env)

// Server
const app = express()
const port = env.SERVER_PORT

// Database
// TODO: define the database

// list of fuctions
require("./api/ping")(app)
require("./api/fetchmyboats")(app, database)
require("./api/fetch_emi")(app, database)
require("./api/fetch_acti")(app, database)
require("./api/fetch_endoi")(app, database)
require("./api/fetch_hpbi")(app, database)
require("./api/fetch_gi")(app, database)
require("./api/fetch_vi")(app, database)
require("./api/fetch_nmea2000")(app, database)

// default route
require("./api/default")(app)

// Available apis
console.log("Saily Apis:")
app._router.stack.forEach(r => {
  if(r.route != undefined){
    console.log("\t"+r.route.path)}
});

// Start Listening
app.listen(port, () => {
  console.log(`Saily server startd at port: ${port}`)
})