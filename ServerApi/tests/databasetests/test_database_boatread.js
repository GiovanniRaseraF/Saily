const env = require("../../envload")
const _ = require("lodash")
const db = require("../../database/mysqldb")(env)

// Database
database = new db();
database.connect();

// test 1
async function test1(){
    // test with not in db
    console.log("Boat wrong password should return undefined")
    boat_id = "";
    mqtt_user = ""; 
    mqtt_password = "";
    let userbyid = await database.getBoatByIdAndMqttUserPass(boat_id, mqtt_user, mqtt_password);
    let ok = userbyid == undefined;
    if(ok){
        console.log("OK :)" + userbyid);
    }else{
        console.log("FAILED :" + userbyid);
    }
}

// test 1
async function test2(){
    console.log("Boat with good gredentials should return an object");
    boat_id = "0x0001";
    mqtt_user = "test"; 
    mqtt_password = "test";
    let userbyid = await database.getBoatByIdAndMqttUserPass(boat_id, mqtt_user, mqtt_password);
    let ok = userbyid != undefined;
    if(ok){
        console.log("OK :)" + userbyid);
    }else{
        console.log("FAILED :" + userbyid);
    }
}

async function test3(){
    // TODO: fix sql injectio
    console.log("Boat should not be able to SQL inject");
    boat_id = "0x0001";
    //mqtt_user = ` '(SELECT mqtt_user FROM boats WHERE boat_id = '${boat_id}')'`; 
    mqtt_user = `'OR ''='`; //TODO: this is sql injection !!!
    mqtt_password = "test";
    let userbyid = await database.getBoatByIdAndMqttUserPass(boat_id, mqtt_user, mqtt_password);
    let ok = userbyid == undefined;
    if(ok){
        console.log("OK :)" + userbyid);
    }else{
        console.log("FAILED :" + userbyid);
    }

    boat_id = "0x0001";
    mqtt_user = `' OR 1 = 1; UPDATE boats SET mqtt_password = '' WHERE boat_id='0x0001'; SELECT * FROM boats WHERE boat_id = '0x0001'; -- `; //TODO: this is sql injection !!!
    mqtt_password = "test";
    userbyid = await database.getBoatByIdAndMqttUserPass(boat_id, mqtt_user, mqtt_password);
    ok = userbyid == undefined;
    if(ok){
        console.log("OK :)" + userbyid);
    }else{
        console.log("FAILED :" + userbyid);
    }
}
async function  test4() {
    console.log("Shoul not be able to read othrer boat if it does not belog to user");
    let user_id = "fakeusername";
    let boat_id = "0x0001";
    const values = await database.get_last_boat_info("nmea2000_vtg_info", -10, boat_id);

    let ok = _.isEqual(values, undefined);
    if(ok){
        console.log("OK :)" + values);
    }else{
        console.log("FAILED :" + values);
    }
}

async function  test5() {
    console.log("Shoul be able to read boat if it belog to user");
    let user_id = 2;
    let boat_id = "0x0010";
    const values = await database.get_last_boat_info("nmea2000_vtg_info", user_id, boat_id);

    let ok = ! _.isEqual(values, []) && ! _.isEqual(values, []);
    if(ok){
        console.log("OK :)" + values);
    }else{
        console.log("FAILED :" + values);
    }
}


async function main(){
    await test1();
    await test2();
    //await test3();
    await test4();
    await test5();

    process.exit(0);
}

main();