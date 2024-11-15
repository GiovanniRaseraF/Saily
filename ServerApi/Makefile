run:
	npm start

test_all:
	make test_out
	make test_boats
	make test_login
	make test_local_database

test_out:
	./runtest.py tests/apitests 0

test_boats:
	./runtest.py tests/boatapitests 0

test_login:
	./runtest.py tests/logintests 0

test_local_database:
	./runtest.py tests/databasetests 0

stress_api:
	./runstress.py tests/apitests 

stress_boats:
	./runstress.py tests/boatapitests

stress_login:
	./runstress.py tests/logintests

simulation:
	node ./tests/simulation/simulatemovement.js

build:
	zip -r ~/Desktop/server.zip \
	'api' \
	'boatapi' \
	'database' \
	'tests' \
	'envload.js' \
	'index.js' \
	'Makefile' \
	'package.json' \
	'readme.md' \
	'runstress.py' \
	'runtest.py'
