#!/bin/bash

#################
# Prerequisites
#################
# yum -y install wget httpd mod_ssl gd gd-devel mariadb-server php-mysql php-xmlrpc gcc mariadb libdbi libdbi-devel libdbi-drivers libdbi-dbd-mysql

#################
# Install Docker
#################

# update repo
apt-get update

# add docker repo
apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" > /etc/apt/sources.list.d/docker.list

# install docker=
apt-get install docker-engine

# start service
service docker start


####################
# Build mysql image
####################
cd ../docker/mysql
docker build -t mysql .

######################
# Run mysql container
######################
docker run --name icinga-mysql-vm -e MYSQL_ROOT_PASSWORD=icinga123 -e MYSQL_USER=icinga -e MYSQL_PASSWORD=icinga123 -e MYSQL_DATABASE=icingadb  -d mysql

######################
# Build apache2 image
######################
cd ../apache2
docker build -t apache2 .

########################
# Run apache2 container
########################
docker run --name icinga-apache-vm -d apache2


###############
# Install CHEF
###############
curl –l https://www.opscode.com/chef/install.sh | bash

#################
# Install Icinga
#################
# cd .../chef
# chef-solo -c solo.rb -j nodes/icinga.json

