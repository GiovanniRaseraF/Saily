// Author: Giovanni Rasera
/*
NAME: fetch_hpbi
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
    const totalVoltage = 0.0; // factor 0.1 V
    const totalCurrent = 0.0; // factor 0.1 A
    const batteryTemperature = 0.0;  // C
    const bmsTemperature = 0.0;      // C
    const SOC = 0.0;                 // %
    const power = 0.0; // factor 0.1 KW +consumata -assorbita
    const tte = 0;        // min
    const auxBatteryVoltage = 0.0; // factor 0.1 V

    const response = {
        totalVoltage,
        totalCurrent,
        batteryTemperature,
        bmsTemperature,
        SOC,
        power,
        tte,
        auxBatteryVoltage
    };

    return response;
}

module.exports = function (app, database) {
    // fetch_highpower_battery_info
    app.post('/fetch_hpbi', function (req, res) {
        const response = createResponse(database);
        const jsonResponse = JSON.stringify(response);
        res.end(jsonResponse);
    });
}