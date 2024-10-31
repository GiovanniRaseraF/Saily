const env = require("../../envload")
const db = require("../../database/mysqldb")(env)
const _ = require("lodash")

// Database
database = new db();
database.connect();

// test 1
async function test1(){
    // test with not in db
    console.log("Cannot insert to databse if wrong password is provided")
    boat_id = "0x0001";
    mqtt_user = ""; 
    mqtt_password = "";
    let response = await database.sendLastBoatNMEA2000VTGInfo(boat_id, mqtt_user, mqtt_password, "{}");
    let ok = response == false;
    if(ok){
        console.log("OK :)" + response);
    }else{
        console.log("FAILED :" + response);
    }
}

// test 2
async function test2(){
    // test with not in db
    console.log("Should return true if credentials are correct")
    boat_id = "0x0001";
    mqtt_user = "test"; 
    mqtt_password = "test";
    let response = await database.isBoatCredentialGood(boat_id, mqtt_user, mqtt_password);
    let ok = response == true;
    if(ok){
        console.log("OK :)" + response);
    }else{
        console.log("FAILED :" + response);
    }
}

// test 3
async function test3(){
    // test with not in db
    console.log("Should return false if credentials are NOT correct")
    boat_id = "0x0001";
    mqtt_user = "fdsajkl"; 
    mqtt_password = "fdsjafkldsjakl";
    let response = await database.isBoatCredentialGood(boat_id, mqtt_user, mqtt_password);
    let ok = response == false;
    if(ok){
        console.log("OK :)" + response);
    }else{
        console.log("FAILED :" + response);
    }
}

// test 4
async function test4(){
    // test with not in db
    console.log("Should return false non a valid boat")
    boat_id = "notvaildboat";
    mqtt_user = "test"; 
    mqtt_password = "test";
    let response = await database.isBoatCredentialGood(boat_id, mqtt_user, mqtt_password);
    let ok = response == false;
    if(ok){
        console.log("OK :)" + response);
    }else{
        console.log("FAILED :" + response);
    }
}

// test 1
async function test5(){
    // test with not in db
    console.log("Cannot insert to databse if wrong password is provided")
    boat_id = "0x0001";
    mqtt_user = "test"; 
    mqtt_password = "test";
    const expected = `{"satellitesCount":1,"isFixed":false,"SOG":2.3,"lat":45.6789,"lng":1.2345678}`;
    let response = await database.sendLastBoatNMEA2000VTGInfo(boat_id, mqtt_user, mqtt_password, expected);
    
    // TODO: implement the actual response by the server
    let actual = await database.getLastBoatNMEA2000VTGInfo("g.rasera@huracanmarine.com", mqtt_user);
    let actualStr = JSON.stringify(actual);
    let expectedlObj = JSON.parse(expected);

    let ok = _.isEqual(actual, expectedlObj);
    if(ok){
        console.log("OK :)" + actualStr);
    }else{
        console.log("FAILED :" + actualStr);
    }
}

async function main(){
    await test1();
    await test2();
    await test3();
    await test4();
    await test5();
    process.exit(0);
}

main();