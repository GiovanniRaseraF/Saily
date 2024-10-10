const dotenv = require("dotenv")
dotenv.config()

const HOST_NAME = process.env.HOST_NAME
const SERVER_PORT = process.env.SERVER_PORT
const DATABASE_USER = process.env.DATABASE_USER
const DATABASE_HOST = process.env.DATABASE_HOST
const DATABASE_NAME = process.env.DATABASE_NAME
const DATABASE_PASSWORD = process.env.DATABASE_PASSWORD

module.exports = {
    HOST_NAME,
    SERVER_PORT,
    DATABASE_USER,
    DATABASE_HOST,
    DATABASE_NAME,
    DATABASE_PASSWORD
}