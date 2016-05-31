#!/bin/bash

#################
# Prerequisites
#################
# yum -y install wget httpd mod_ssl gd gd-devel mariadb-server php-mysql php-xmlrpc gcc mariadb libdbi libdbi-devel libdbi-drivers libdbi-dbd-mysql

#################
# Install Docker
#################

# update yum
yum -y update

# add docker repo
tee /etc/yum.repos.d/docker.repo <<-EOF
[dockerrepo]
name=Docker Repository
baseurl=https://yum.dockerproject.org/repo/main/centos/7
enabled=1
gpgcheck=1
gpgkey=https://yum.dockerproject.org/gpg
EOF

# install docker-io
yum -y install docker-engine

# Add disk increase parameter
sed -i "s/other_args=/other_args='--storage-driver=devicemapper --storage-opt dm.basesize=30G'/g" /etc/sysconfig/docker

# Remove default libraries - IT WILL REMOVE ALL IMAGES
rm -rf /var/lib/docker/

# Start docker service again
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
cd ../docker/apache2
docker build -t apache2 .

########################
# Run apache2 container
########################
docker run --name icinga-apache-vm2 -d apache2


###############
# Install CHEF
###############
curl –l https://www.opscode.com/chef/install.sh | bash

#################
# Install Icinga
#################
# cd .../chef
# chef-solo -c solo.rb -j nodes/icinga.json

