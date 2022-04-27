#!/bin/bash
sudo apt-get update -y
wget -qO - https://www.mongodb.org/static/pgp/server-4.4.asc | sudo apt-key add -
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/4.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.4.list
sudo apt-get -y update
sudo apt-get install -y curl
curl -sL https://deb.nodesource.com/setup_12.x | sudo bash -
sudo apt-get install -y build-essential mongodb-org nodejs graphicsmagick
sudo apt install npm -y
sudo npm install -g inherits n
sudo ln -s /usr/bin/node /usr/local/bin/node
