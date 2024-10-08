/*
NAME: ping
INPUT: {}
OUTPUT:{
    "date" : "2024-.....",
    "server_version" : "1.0"
}
*/
function createResponse(){
    const date = Date(Date.now());
    const server_ip = "1.1";

    const response = {
        date,
        server_ip
    };

    return response;
}

module.exports = function (app) {
    // ping
    app.get('/ping', function (req, res) {
        const response = createResponse();
        const jsonResponse = JSON.stringify(response);

        res.end(jsonResponse);
    });
}