#!/usr/bin/env bash

set -x #echo on

# Assuming ssh-agent forwarding is on, add github to known hosts
sudo mkdir ~/.ssh
sudo chown $USER.$USER ~/.ssh/
sudo touch ~/.ssh/known_hosts
sudo ssh-keyscan -H github.com >> ~/.ssh/known_hosts

sudo apt-get update &> /dev/null

# Install main dependencies
sudo apt-get -y install ssh git curl npm nodejs-legacy vim &> /dev/null

# Install assimp
sudo apt-get -y install assimp-utils &> /dev/null

# Install mongodb
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | sudo tee /etc/apt/sources.list.d/mongodb.list
sudo apt-get update &> /dev/null
sudo apt-get install -y mongodb-org &> /dev/null

# Install building-database
cd ~
git clone git@github.com:polygon-city/building-database.git
cd building-database
sudo npm update &> /dev/null
npm install &> /dev/null
sudo mkdir -p /data/db

# Setup mongodb
mongo localhost:27017/building-database /vagrant/mongo-setup.js

cp /vagrant/config.js config/config.js
# npm install &> /dev/null
sudo npm install -g bower grunt-cli &> /dev/null
bower install --allow-root &> /dev/null
DEBUG=polygoncity grunt
