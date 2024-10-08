// Author: Giovanni Rasera
/*
NAME: fetch_electric_motor_info
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
*/

function createResponse(database) {
    const busVoltage = 0.0;
    const motorCurrent = 0.0;
    const inverterTemperature = 0.0;
    const motorTemperature = 0.0;
    const motorRPM = 0.0;

    const response = {
        busVoltage,
        motorCurrent,
        inverterTemperature,
        motorTemperature,
        motorRPM
    };

    return response;
}

module.exports = function (app, database) {
    // fetchmyboats
    app.post('/fetch_electric_motor_info', function (req, res) {
        const response = createResponse(database);
        const jsonResponse = JSON.stringify(response);
        res.end(jsonResponse);
    });
}