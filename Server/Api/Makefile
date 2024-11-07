all:
	docker compose up -d

loadbd:
	docker exec -it api-mysqldatabase-1 sh -c "mysql -uroot -proot < /home/databasev2.sql"

exp: 
	source .env

usercreate:
	@ # make usercreate DATABASE_NAME=$DATABASE_NAME  DATABASE_USER=$DATABASE_USER DATABASE_PASSWORD=$DATABASE_PASSWORD
	@ echo "Define:\n DATABASE_NAME=${DATABASE_NAME}\n DATABASE_USER=${DATABASE_USER}\n DATABASE_PASSWORD=${DATABASE_PASSWORD}"
	docker exec -it api-mysqldatabase-1 sh -c "mysql -u root -proot -e \"CREATE USER '${DATABASE_USER}'@'%' IDENTIFIED BY '${DATABASE_PASSWORD}';\""
	docker exec -it api-mysqldatabase-1 sh -c "mysql -u root -proot -e \"GRANT ALL PRIVILEGES ON ${DATABASE_NAME}.* TO '${DATABASE_USER}'@'%';\"" 
	docker exec -it api-mysqldatabase-1 sh -c "mysql -u root -proot -e \"FLUSH PRIVILEGES;\""

mysqlbash:
	@ # make mysqlbash DATABASE_NAME=$DATABASE_NAME
	@ echo "Define:\n DATABASE_NAME=${DATABASE_NAME}"
	docker exec -it api-mysqldatabase-1 mysql -uroot -proot ${DATABASE_NAME}
	# mysql -uroot -proot

# source .env
# make loadbd
# make usercreate DATABASE_NAME=$DATABASE_NAME  DATABASE_USER=$DATABASE_USER DATABASE_PASSWORD=$DATABASE_PASSWORD
# make mysqlbash DATABASE_NAME=$DATABASE_NAME