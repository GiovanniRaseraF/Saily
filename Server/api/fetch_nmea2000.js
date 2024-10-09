// Author: Giovanni Rasera
/*
NAME: /fetch_nmea2000/vtgi
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

function createResponseVTGI(database) {
    const satellitesCount = 0;
    const isFixed = false;
    const SOG = 0; // usualy in km/hr from NMEA2000
    const lat = 0;
    const lng = 0;

    const response = {
        satellitesCount,
        isFixed,
        SOG,
        lat,
        lng
    };

    return response;
}

function createResponseABCI(database) {
    const info = "abci"
    const response = {
        info 
    };

    return response;
}

module.exports = function (app, database) {
    app.post('/fetch_nmea2000/vtgi', function (req, res) {
        const response = createResponseVTGI(database);
        const jsonResponse = JSON.stringify(response);
        res.end(jsonResponse);
    });

    app.post('/fetch_nmea2000/abci', function (req, res) {
        const response = createResponseABCI(database);
        const jsonResponse = JSON.stringify(response);
        res.end(jsonResponse);
    });
}