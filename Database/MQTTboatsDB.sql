/*
** Author Lorenzo Mancini
** database di connessione MQTT utente-barca con autenticazione
*/

/*
** DROP DATABASE IF EXISTS MQTTboatsDB;
** CREATE DATABASE MQTTboatsDB;
*/

DROP TABLE IF EXISTS user_account CASCADE;
DROP TABLE IF EXISTS boats CASCADE;

CREATE table user_account (
    user_id SERIAL NOT NULL,
    user_email VARCHAR(500) NOT NULL, 
    password_hash VARCHAR(500) NOT NULL,
    PRIMARY KEY (user_id)
);

CREATE table boats (
    boat_id VARCHAR(20) NOT NULL,
    MQTT_user VARCHAR(10) NOT NULL, 
    MQTT_password VARCHAR(100) NOT NULL,
    user_id INTEGER NOT NULL,
    CONSTRAINT pk PRIMARY KEY (boat_id),
    CONSTRAINT fk_user 
		FOREIGN KEY(user_id)
			REFERENCES user_account(user_id)
			ON UPDATE NO ACTION
			ON DELETE NO ACTION
);

