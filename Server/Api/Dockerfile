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

COPY .env /
RUN export $(cat .env | xargs)
# RUN mysql -u root -p -e "CREATE USER '$DATABASE_USER'@'%' IDENTIFIED BY '$DATABASE_PASSWORD';"
# RUN mysql -u root -p -e "GRANT ALL PRIVILEGES ON $DATABASE_NAME.* TO '$DATABASE_USER'@'%';"
# RUN mysql -u root -p -e "FLUSH PRIVILEGES;"

RUN echo "(cd /Saily/ServerApi && make) &" >> /etc/init.d/runserver.sh