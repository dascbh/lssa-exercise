#!/bin/bash

#################
# Install Docker
#################

wget http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
rpm -Uvh epel-release-6-8.noarch.rpm
yum -y install docker-io.x86_64

# stop docker service
#service docker stop

# Add disk increase parameter
sed -i "s/other_args=/other_args='--storage-driver=devicemapper --storage-opt dm.basesize=30G'/g" /etc/sysconfig/docker

# Remove default libraries - IT WILL REMOVE ALL IMAGES
rm -rf /var/lib/docker/

# Start docker service again
service docker start


# ####################
# # Build mysql image
# ####################
# cd docker/mysql
# docker build -t mysql .

# ######################
# # Run mysql container
# ######################
# docker run --name icinga-mysql-vm -e MYSQL_ROOT_PASSWORD=icinga123 -e MYSQL_USER=icinga -e MYSQL_PASSWORD=icinga123 -e MYSQL_DATABASE=icingadb  -d mysql

# ######################
# # Build apache2 image
# ######################
# cd docker/apache2
# docker build -t apache2:latest .

# ########################
# # Run apache2 container
# ########################
# docker run -it --rm --name icinga-apache-vm apache2



###############
# Install CHEF
###############
curl –l https://www.opscode.com/chef/install.sh | bash