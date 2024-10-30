// Author: Giovanni Rasera
/*
NAME: fetch_emi
INPUT: {
    "user_id" : "12345",
    "user_auth" : "fdsa"
    "boat_id" : "4320"
}
OUTPUT:{
  "busVoltage" : 0.0,         // factor 0.1 V
  "motorCurrent : 0.0,        // factor 0.1 A
  "inverterTemperature : 0.0, // C
  "motorTemperature" : 0.0,   // C
  "motorRPM" : 0.0            // RPM 
}

or 

error_authentication

or 

error_boat_id
*/

const errors = require("./errors");

async function createResponse(database, req) {
    const { username, password, boat_id} = req.body;

    let canlogin = await database.isUserInDb(username, password);
    if (canlogin) {
        // OK
        return await database.getLastBoatElectricMotorInfo(username, boat_id);
    } else {
        // NO
        return errors.error_authentication;
    }

    return errors.error_authentication;
}

module.exports = function (app, database) {
    database.connect();
    // fetch_electric_motor_info
    app.post('/fetch_emi', async function (req, res) {
        const response = await createResponse(database, req);
        const jsonResponse = JSON.stringify(response);
        res.end(jsonResponse);
    });
}