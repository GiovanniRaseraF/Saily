// Author: Giovanni Rasera
/*
NAME: /send_acti
INPUT: 
}
*/

const { error_boat_authentication } = require("../api/errors");

async function createResponse(database, req) {
    const { mqtt_user, mqtt_password, boat_id, actual_message} = req.body;

    const good = await database.sendLastBoatActuatorInfo(boat_id, mqtt_user, mqtt_password, actual_message);
    if(good){
        return {};
    }else{
        return error_boat_authentication;
    }
}

module.exports = function (app, database) {
    database.connect();
    
    app.post('/send_acti', async function (req, res) {
        const response = await createResponse(database, req);
        const jsonResponse = JSON.stringify(response);
        res.end(jsonResponse);
    });
}