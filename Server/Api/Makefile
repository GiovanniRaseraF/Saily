all:
	docker build . -t saily_server_v1 

run:
	docker run -d saily_server_v1

bash:
	docker run -p 8567:8080 -it saily_server_v1 bash 
