const env = require("../envload")
const db = require("../database/mysqldb")(env)

// Database
database = new db();
database.connect();

async function main(){
    // test with not in db
    username = "test";
    password = "test";
    let userbyid = await database.getUserByNameAndPassword(username, password);
    let canlogin = await database.isUserInDb(username, password);
    console.log(userbyid);
    console.log(canlogin);

    // test in db
    username = "g.rasera@huracanmarine.com";
    password = "MoroRacing2024";
    userbyid = await database.getUserByNameAndPassword(username, password);
    canlogin = await database.isUserInDb(username, password);
    console.log(userbyid);
    console.log(canlogin);
}

main();