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

const errors = require("./errors");

async function createResponseVTGI(database, req) {
    const { username, password, boat_id} = req.body;

    let canlogin = await database.isUserInDb(username, password);
    if (canlogin) {
        // OK
        return await database.getLastBoatNMEA2000VTGInfo(username, boat_id);
    } else {
        // NO
        return errors.error_authentication;
    }

    return errors.error_authentication;
}

function createResponseABCI(database) {
    const info = "abci"
    const response = {
        info 
    };

    return response;
}

module.exports = function (app, database) {
    app.post('/fetch_nmea2000/vtgi', async function (req, res) {
        const response = await createResponseVTGI(database, req);
        const jsonResponse = JSON.stringify(response);
        res.end(jsonResponse);
    });

    app.post('/fetch_nmea2000/abci', function (req, res) {
        const response = createResponseABCI(database);
        const jsonResponse = JSON.stringify(response);
        res.end(jsonResponse);
    });
}