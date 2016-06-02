#!/bin/bash

################
# Prerequisites
################
mkdir /logs
mkdir /logs/mysql
mkdir /logs/apache2

#################
# Install Docker
#################

# add docker repo
apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" > /etc/apt/sources.list.d/docker.list

# install docker
apt-get update -y
apt-get install docker-engine -y

####################
# Build mysql image
####################
cd docker/mysql
docker build -t mysql .

######################
# Run mysql container
######################
docker run --name icinga-mysql-vm -e MYSQL_ROOT_PASSWORD=icinga123 -e MYSQL_USER=icinga -e MYSQL_PASSWORD=icinga123 -e MYSQL_DATABASE=icinga_db  -v /logs:/var/logs -d mysql

######################
# Build apache2 image
######################
cd ../apache2
docker build -t apache2 .

########################
# Run apache2 container
########################
docker run --name icinga-apache-vm -v /logs/:/var/log -d apache2

###############
# Install CHEF
###############
cd ../../chef
curl –l https://www.opscode.com/chef/install.sh | bash

#################
# Install Icinga
#################
chef-solo -c solo.rb -j nodes/icinga.json

####################
# Print icinga token
####################
echo "Icinga2 Web Setup Wizard URL"
echo "http://<server address>/icingaweb2/"

icingacli setup token show
