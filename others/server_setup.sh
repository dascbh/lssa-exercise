#!/bin/bash

# Preliminary configs

# Install Docker

# Install CHEF
cd chef
dpkg -i chef_12.10.24-1_amd64.deb


# Build mysql image
cd docker/mysql
docker build -t mysql .

# Run mysql container
docker run --name icinga-mysql-vm -e MYSQL_ROOT_PASSWORD=icinga123 -e MYSQL_USER=icinga -e MYSQL_PASSWORD=icinga123 -e MYSQL_DATABASE=icingadb  -d mysql

# Build apache2 image
cd docker/apache2
docker build -t apache2 .

# Run apache2 container
docker run -it --rm --name icinga-apache-vm apache2