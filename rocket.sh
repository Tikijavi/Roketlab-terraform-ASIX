#!/bin/bash
sudo apt-get update -y
sudo apt install openssl -y
sudo openssl req -newkey rsa:4096 -x509 -sha256 -days 3650 -nodes -subj "/C=ES/ST=barcelona/L=Barcelona/O=GrupoJavi" -out /etc/ssl/certs/rocket.crt -keyout /etc/ssl/private/rocket.key
sudo apt-get install nginx -y
sudo mv /etc/nginx/sites-available/default /etc/nginx/sites-available/default.reference
touch /etc/nginx/sites-available/default
cat << EOF |sudo tee -a /etc/nginx/sites-available/default
server {
    listen 443 ssl;
    server_name repte3.ddns.net;
    ssl_certificate /etc/ssl/certs/rocket.crt;
    ssl_certificate_key /etc/ssl/private/rocket.key;
    ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
    ssl_prefer_server_ciphers on;
    ssl_ciphers 'EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH';
    root /usr/share/nginx/html;
    index index.html index.htm;
    # Make site accessible from http://localhost/
    server_name localhost;
    location / {
        proxy_pass http://localhost:3000/;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host \$http_host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto http;
        proxy_set_header X-Nginx-Proxy true;
        proxy_redirect off;
    }
}
server {
    listen 80;
    server_name repte3.ddns.net;
    return 301 https://\$host\$request_uri;
}
EOF
sudo nginx -t
sudo systemctl restart nginx
sudo apt-get update -y
sudo apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
# confirm the fingerprint matches "9DC8 5822 9FC7 DD38 854A E2D8 8D81 803C 0EBF CD88"
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update -y
sudo apt-get install docker-ce docker-ce-cli containerd.io -y
sudo curl -L "https://github.com/docker/compose/releases/download/1.26.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo mkdir -p /opt/docker/rocket.chat/data/runtime/db
sudo mkdir -p /opt/docker/rocket.chat/data/dump
cat << EFO |sudo tee -a /opt/docker/rocket.chat/docker-compose.yml
version: '2'
services:
  rocketchat:
    image: rocket.chat:latest
    command: >
      bash -c
        "for i in 'seq 1 30'; do
          node main.js &&
          s=$$? && break || s=$$?;
          echo \"Tried $$i times. Waiting 5 secs...\";
          sleep 5;
        done; (exit $$s)"
    restart: unless-stopped
    volumes:
      - ./uploads:/app/uploads
    environment:
      - PORT=3000
      - ROOT_URL=https://repte3.ddns.net
      - MONGO_URL=mongodb://mongo:27017/rocketchat
      - MONGO_OPLOG_URL=mongodb://mongo:27017/local
    depends_on:
      - mongo
    ports:
      - 3000:3000
  mongo:
    image: mongo:4.0
    restart: unless-stopped
    command: mongod --smallfiles --oplogSize 128 --replSet rs0 --storageEngine=mmapv1
    volumes:
      - ./data/runtime/db:/data/db
      - ./data/dump:/dump
  # this container's job is just to run the command to initialize the replica set.
  # it will run the command and remove himself (it will not stay running)
  mongo-init-replica:
    image: mongo:4.0
    command: >
      bash -c
        "for i in 'seq 1 30'; do
          mongo mongo/rocketchat --eval \"
            rs.initiate({
              _id: 'rs0',
              members: [ { _id: 0, host: 'localhost:27017' } ]})\" &&
          s=$$? && break || s=$$?;
          echo \"Tried $$i times. Waiting 5 secs...\";
          sleep 5;
        done; (exit $$s)"
    depends_on:
    - mongo
EFO
cd /opt/docker/rocket.chat
sudo docker-compose up -d
