FROM ubuntu:22.04

RUN apt update -y
RUN apt upgrade -y

RUN apt install git wget nodejs -y
RUN apt install git wget npm -y
RUN apt install mysql-server -y
RUN apt install net-tools -y
RUN apt install htop -y

RUN git clone https://github.com/GiovanniRaseraF/Saily.git
RUN touch /etc/init.d/runserver.sh && chmod +x /etc/init.d/runserver.sh
RUN cd /Saily/ServerApi && npm install
COPY .env /Saily/ServerApi/

RUN echo "(cd /Saily/ServerApi && make) &" >> /etc/init.d/runserver.sh