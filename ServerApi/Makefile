run:
	npm start

test_all:
	make test_out
	make test_boats
	make test_login
	make test_local_database

test_out:
	./runtest.py tests/apitests 1

test_boats:
	./runtest.py tests/boatapitests 1

test_login:
	./runtest.py tests/logintests 1

test_local_database:
	./runtest.py tests/databasetests 1

stress_api:
	./runstress.py tests/apitests 

stress_boats:
	./runstress.py tests/boatapitests

stress_login:
	./runstress.py tests/logintests