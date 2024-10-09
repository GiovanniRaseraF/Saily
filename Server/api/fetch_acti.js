// Author: Giovanni Rasera
/*
NAME: fetch_acti
INPUT: {
    "user_id" : "12345",
    "user_auth" : "fdsa"
    "boat_id" : "4320"
}
OUTPUT:{
    "pedal" = 0,
    "requestedGear" : 0,
    "validatedGear" : 0,
    "pedalTrim" : 0
}

or 

error_authentication

or 

error_boat_id
*/

function createResponse(database) {
    const pedal = 0; // %
    const requestedGear = 0;
    const validatedGear = 0;
    const pedalTrim = 0;

    const response = {
        pedal,
        requestedGear ,
        validatedGear ,
        pedalTrim
    };

    return response;
}

module.exports = function (app, database) {
    // fetch_actuator_info
    app.post('/fetch_acti', function (req, res) {
        const response = createResponse(database);
        const jsonResponse = JSON.stringify(response);
        res.end(jsonResponse);
    });
}