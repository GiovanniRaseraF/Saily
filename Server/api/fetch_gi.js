// Author: Giovanni Rasera
/*
NAME: fetch_gi
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

function createResponse(database) {
    const isHybrid = false; // false = FullElectric , true = Hybrid
    const isDualMotor = false; // false = SingleMotor, true = DualMotor
    const versionProtocol = 0.0; // factor 0.1
    const versionFWControlUnit = 0.0; // factor 0.01
    const versionFWDrive = 0.0; // factor 0.01
    const dieselMotorModel = 0; // DieselMotorModel.None; // Tabella 1
    const electricMotorModel = 0; //ElectricMotorModel.None; // Tabella 2

    const response = {
        isHybrid,
        isDualMotor,
        versionProtocol,
        versionFWControlUnit,
        versionFWDrive,
        dieselMotorModel,
        electricMotorModel
    };

    return response;
}

module.exports = function (app, database) {
    // fetch_generic_info
    app.post('/fetch_gi', function (req, res) {
        const response = createResponse(database);
        const jsonResponse = JSON.stringify(response);
        res.end(jsonResponse);
    });
}