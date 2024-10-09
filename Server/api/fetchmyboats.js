// Author: Giovanni Rasera
/*
NAME: fetchbyboats 
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

// TODO: define a boat

function createResponse(database){
    boats = []; // load from database

    const response = {
        boats
    };

    return response;
}

module.exports = function (app, database) {
    // fetchmyboats
    app.post('/fetchmyboats', function (req, res) {
        const response = createResponse(database);
        const jsonResponse = JSON.stringify(response);
        res.end(jsonResponse);
    });
}