// Author: Giovanni Rasera
/*
NAME: /send_nmea2000/vtgi
INPUT: {
    "boat_id" : "0x0",
    "mqtt_pass" : "fdsa",
    "mqtt_user" : "fdsa",
    "actual_message" : {
        "" : "",
        "" : ""
    }
}
*/

const { error_boat_authentication } = require("../api/errors");

async function createResponseVTGI(database, req) {
    const { mqtt_user, mqtt_password, boat_id, actual_message} = req.body;

    const good = await database.sendLastBoatNMEA2000VTGInfo(boat_id, mqtt_user, mqtt_password, actual_message);
    if(good){
        return {};
    }else{
        return error_boat_authentication;
    }
}

function createResponseABCI(database) {
    const response = {
    };

    return response;
}

module.exports = function (app, database) {
    database.connect();
    
    app.post('/send_nmea2000/vtgi', async function (req, res) {
        const response = await createResponseVTGI(database, req);
        const jsonResponse = JSON.stringify(response);
        res.end(jsonResponse);
    });

    app.post('/send_nmea2000/abci', function (req, res) {
        const response = createResponseABCI(database);
        const jsonResponse = JSON.stringify(response);
        res.end(jsonResponse);
    });
}