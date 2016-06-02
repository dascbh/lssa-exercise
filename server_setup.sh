#!/bin/bash

#################
# Install Docker
#################

# add docker repo
apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" > /etc/apt/sources.list.d/docker.list

# update repo
apt-get update

# install docker
apt-get install docker-engine -y

# start service
service docker start

####################
# Build mysql image
####################
cd docker/mysql
docker build -t mysql .

######################
# Run mysql container
######################
docker run --name icinga-mysql-vm -e MYSQL_ROOT_PASSWORD=icinga123 -e MYSQL_USER=icinga -e MYSQL_PASSWORD=icinga123 -e MYSQL_DATABASE=icinga_db  -d mysql

######################
# Build apache2 image
######################
cd ../apache2
docker build -t apache2 .

########################
# Run apache2 container
########################
docker run --name icinga-apache-vm -d apache2


#####################
# Setup log collector
#####################

mkdir /logs
mkdir /logs/mysql
mkdir /logs/httpd

apt-get install python-pip

pip install awscli --ignore-installed six

echo "aws_access_key_id = AKIAJHH4MD436X35JZYQ" >> /root/.aws/credentials
echo "aws_secret_access_key = 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" >> /root/.aws/credentials

# 00 07 * * * /usr/bin/somedirectory/somecommand

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
