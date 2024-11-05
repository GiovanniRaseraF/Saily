// Author: Giovanni Rasera
/*
NAME: fetch_vi
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

async function createResponse(database, req) {
    const { username, password, boat_id} = req.body;

    let canlogin = await database.isUserInDb(username, password);
    if (canlogin) {
        // OK
        const user = await database.getUserByNameAndPassword(username, password);
        const res = await database.getLastBoatVehicleInfo(user.user_id, boat_id);
        if(res == undefined) return errors.error_boat_id;
        return res;
    } else {
        // NO
        return errors.error_authentication;
    }

    return errors.error_authentication;
}

module.exports = function (app, database) {
    database.connect();
    // fetch_vehicle_info
    app.post('/fetch_vi', async function (req, res) {
        const response = await createResponse(database, req);
        const jsonResponse = JSON.stringify(response);
        res.end(jsonResponse);
    });
}