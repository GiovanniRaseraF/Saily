// Author: Giovanni Rasera
/*
NAME: fetch_endoi
INPUT: {
    "user_id" : "12345",
    "user_auth" : "fdsa"
    "boat_id" : "4320"
}
OUTPUT:{ 
}

or 

error_authentication

or 

error_boat_id
*/

function createResponse(database) {
    const motorRPM = 0; // RPM
    const refrigerationTemperature = 0.0; // C
    const batteryVoltage = 0.0; // factor 0.1 V
    const throttlePedalPosition = 0; // %
    const glowStatus = 0; //GlowStatus.OFF
    const dieselStatus = 0; // DieselStatus.WAIT;
    const fuelLevel1 = 0; // %
    const fuelLevel2 = 0; // %

    const response = {
        motorRPM,
        refrigerationTemperature,
        batteryVoltage,
        throttlePedalPosition,
        glowStatus,
        dieselStatus,
        fuelLevel1,
        fuelLevel2
    };

    return response;
}

module.exports = function (app, database) {
    // fetch_endotermic_motor_info
    app.post('/fetch_endoi', function (req, res) {
        const response = createResponse(database);
        const jsonResponse = JSON.stringify(response);
        res.end(jsonResponse);
    });
}