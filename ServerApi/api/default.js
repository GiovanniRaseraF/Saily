// Author: Giovanni Rasera
/*
INPUT: {}
OUTPUT: error_api_call_invalid
*/

const error_api_call_invalid = require("./errors");

function createResponse() {
    return error_api_call_invalid;
}

module.exports = function (app) {
    // default
    app.post('*', function (req, res) {
        const response = createResponse();
        const jsonResponse = JSON.stringify(response);
        res.end(jsonResponse);
    });
}