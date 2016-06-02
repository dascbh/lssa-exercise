#!/bin/bash
#################################################################################################
#																								#
#	Author: Daniel Costa <dascbh@gmail.com>														#
#	Description: This script should orchestrate the process to build the environment proposed	#
#	Last Change: 02/06/16																		#
#																								#
#################################################################################################

################
# Prerequisites
################

# Create log directories for future usage
mkdir /logs
mkdir /logs/mysql
mkdir /logs/apache2

#################
# Install Docker
#################

# Add docker repo
apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" > /etc/apt/sources.list.d/docker.list

# Install docker package
apt-get update -y
apt-get install docker-engine -y

####################
# Build mysql image
####################

# build a docker image for mysql
cd docker/mysql
docker build -t mysql .

######################
# Run mysql container
######################

# create mysql container
docker run --name icinga-mysql-vm -e MYSQL_ROOT_PASSWORD=icinga123 -e MYSQL_USER=icinga -e MYSQL_PASSWORD=icinga123 -e MYSQL_DATABASE=icinga_db  -v /logs/mysql:/var/log -d mysql

######################
# Build apache2 image
######################

# build a docker image for apache2
cd ../apache2
docker build -t apache2 .

########################
# Run apache2 container
########################

# create the apache2 container
docker run --name icinga-apache-vm -v /logs/apache2:/var/log -d apache2

###############
# Install CHEF
###############

# change dir and install chef
cd ../../chef
curl –l https://www.opscode.com/chef/install.sh | bash

#################
# Install Icinga
#################

# execute the chef scripts to install icinga and others
chef-solo -c solo.rb -j nodes/icinga.json

####################
# Print icinga token
####################
echo "Icinga2 Web Setup Wizard URL"
echo "http://<server address>/icingaweb2/"

icingacli setup token show
service icinga2 reload
