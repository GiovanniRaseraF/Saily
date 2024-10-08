// Author: Giovanni Rasera

// This server is designed to handle fetching 
// requests form Saily Application

const express = require('express')
const path = require('path')

// Server
const app = express()
const port = 8567

// list of fuctions
require("./ping")(app)

// Start Listening
app.listen(port, () => {
  console.log(`Saily server startd at port: ${port}`)
})