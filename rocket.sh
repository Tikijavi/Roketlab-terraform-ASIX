#!/bin/bash
sudo apt-get update -y
#mongodb quitar despues de que shakir haga cosas UwU
wget -qO - https://www.mongodb.org/static/pgp/server-4.4.asc | sudo apt-key add -
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/4.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.4.list
sudo apt-get -y update
sudo apt-get install -y curl
curl -sL https://deb.nodesource.com/setup_12.x | sudo bash -
sudo apt-get install -y build-essential mongodb-org nodejs graphicsmagick
sudo apt install npm -y
sudo npm install -g inherits n
sudo ln -s /usr/bin/node /usr/local/bin/node
#Install Rocketchat
curl -L https://releases.rocket.chat/latest/download -o /tmp/rocket.chat.tgz
tar -xzf /tmp/rocket.chat.tgz -C /tmp
cd /tmp/bundle/programs/server && npm install
cd ~/
sudo mv /tmp/bundle /opt/Rocket.Chat
#User rocketchat
sudo useradd -M rocketchat
sudo usermod -L rocketchat
sudo chown -R rocketchat:rocketchat /opt/Rocket.Chat
#Porros
cat << EOF |sudo tee -a /etc/systemd/system/rocketchat.service
[Unit]
Description=The Rocket.Chat server
After=network.target remote-fs.target nss-lookup.target nginx.service mongod.service
[Service]
ExecStart=/usr/local/bin/node /opt/Rocket.Chat/main.js
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=rocketchat
User=rocketchat
Environment=MONGO_URL=mongodb://localhost:27017/rocketchat?replicaSet=rs01 MONGO_OPLOG_URL=mongodb://localhost:27017/local?replicaSet=rs01 ROOT_URL=http://localhost:3000/ PORT=3000
[Install]
WantedBy=multi-user.target
EOF
sudo sed -i "s/^#replication:/replication:\n  replSetName: rs01/" /etc/mongod.conf
sudo systemctl daemon-reload
sudo systemctl enable mongod
sudo systemctl restart mongod
sudo systemctl enable rocketchat
sudo systemctl start rocketchat
#NJINX
sudo apt install nginx -y
cd /etc/nginx/sites-available
sudo nano /etc/nginx/sites-available/default
# - crear página web falta -
#Let's Encript
sudo apt install certbot python3-certbot-nginx -y
#Lo mismo que lo anterior
