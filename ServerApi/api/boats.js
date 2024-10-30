// Author: Giovanni Rasera
/*
NAME: boats 
INPUT: {
    "user_id" : "12345",
    "user_auth" : "fdsa"
}
OUTPUT:{
    "boats" : [
        {}, // boat 1
        {}, // boat 2
        {}, // boat n
    ]
}

or

error_authentication
*/

const errors = require("./errors")

// TODO: define a boat

async function createResponse(database, req) {
    const { username, password } = req.body;

    let canlogin = await database.isUserInDb(username, password);

    if (canlogin) {
        // OK
        const user = await database.getUserByNameAndPassword(username, password);
        const boatsResult = await database.getBoatsFromId(user.user_id);
        return {
            "boats": boatsResult,
        };
    } else {
        // NO
        return errors.error_authentication;
    }
}

module.exports = function (app, database) {
    database.connect();
    // fetch my boats
    app.post('/boats', async function (req, res) {
        const response = await createResponse(database, req);
        const jsonResponse = JSON.stringify(response);
        res.end(jsonResponse);
    });
}