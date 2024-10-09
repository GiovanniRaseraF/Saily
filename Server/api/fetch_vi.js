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

function createResponse(database) {
    let vehicleStatus = 0; //VehicleStatus.WAIT;
    let isHybrid = false;
    let isElectric = false;
    let isDiesel = false;
    let isSeaWaterPressureOK = false;
    let isGlicolePressureOK = false;
    let isLowSocLevel = false;
    let sealINTemperature = 0.0; // C
    let sealOUTTemperature = 0.0; // C
    let glicoleINTemperature = 0.0; // C
    let glicoleOUTTemperature = 0.0; // C
    let isECUOn = false;
    let isDCUOn = false;
    let voltageToECU = 0.0; // factor 0.1 V

    let timecounter = 0; //min
    let timecounterElectricMotor = 0; //min
    let timecounterDieselMotor = 0; //min 

    const response = {
        vehicleStatus,
        isHybrid,
        isElectric,
        isDiesel,
        isSeaWaterPressureOK,
        isGlicolePressureOK,
        isLowSocLevel,
        sealINTemperature,
        sealOUTTemperature,
        glicoleINTemperature,
        glicoleOUTTemperature,
        isECUOn,
        isDCUOn,
        voltageToECU,
        timecounter,
        timecounterElectricMotor,
        timecounterDieselMotor
    };

    return response;
}

module.exports = function (app, database) {
    // fetch_vehicle_info
    app.post('/fetch_vi', function (req, res) {
        const response = createResponse(database);
        const jsonResponse = JSON.stringify(response);
        res.end(jsonResponse);
    });
}