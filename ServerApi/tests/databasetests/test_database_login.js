const env = require("../../envload")
const db = require("../../database/mysqldb")(env)

// Database
database = new db();
database.connect();

// test 1
async function test1(){
    // test with not in db
    console.log("User not in database, Should return undefined")
    username = "";
    password = "";
    let userbyid = await database.getUserByNameAndPassword(username, password);
    let canlogin = await database.isUserInDb(username, password);
    let ok = userbyid == undefined;
    if(ok){
        console.log("OK :)" + userbyid);
    }else{
        console.log("FAILED :" + userbyid);
    }
}

// test 1
async function test2(){
    // test with not in db
    console.log("User in database, Should return object")
    username = "g.rasera@huracanmarine.com";
    password = "MoroRacing2024";
    let userbyid = await database.getUserByNameAndPassword(username, password);
    let canlogin = await database.isUserInDb(username, password);
    let ok = userbyid != undefined;
    if(ok){
        console.log("OK :)" + userbyid);
    }else{
        console.log("FAILED :" + userbyid);
    }
}

async function main(){
    await test1();
    await test2();
    process.exit(0);
}

main();