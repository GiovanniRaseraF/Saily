// Author: Giovanni Rasera
/*
INPUT: {}
OUTPUT:{
    "date" : "2024-.....",
    "version" : "1.0"
}
*/

function createResponse(){
    const date = Date(Date.now());
    const version = "1.1";

    const response = {
        date,
        version 
    };

    return response;
}

module.exports = function (app) {
    // default
    app.post('/*', function (req, res) {
        const response = createResponse();
        const jsonResponse = JSON.stringify(response);
        res.end(jsonResponse);
    });
}