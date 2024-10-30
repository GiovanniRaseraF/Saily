
// Author: Giovanni Rasera
/*
NAME: login
INPUT: {
}
OUTPUT:{
    canlogin : heo
}

or 

error_authentication

*/

const errors = require("./errors");

async function createResponse(database, req) {
    const { username, password } = req.body;

    let canlogin = await database.isUserInDb(username, password);

    if (canlogin) {
        // OK
        return {
            "canuselogin": true,
        };

    } else {
        // NO
        return errors.error_authentication;
    }
}

module.exports = function (app, database) {
    database.connect();
    // fetch_electric_motor_info
    app.post('/login', async function (req, res) {
        const response = await createResponse(database, req);
        const jsonResponse = JSON.stringify(response);
        res.end(jsonResponse);
    });
}