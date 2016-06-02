#
# Cookbook Name:: icinga
# Recipe:: icinga2
#
# Copyright (c) 2016 Daniel Costa, All Rights Reserved.
#
# Description: Install Icinga2 Monitoring
#
# Version: 0.1.0
#*********************************************************************************
# Change Log:
#
# Developer		Date		Description
# ---------		--------	----------------------------------------------------
# dasc			05/30/16	Creation
#
#*********************************************************************************

########################
# Create application id
########################

# Secret: Just4Now
user 'icingacmd' do
  action :create
  password '$1$Jgpvs8I0$frhas54j6yKouoFYINrvX/'
end

###########################
# Install required packages
############################

# add icinga repo and update first
bash 'install repo' do
  user 'root'
  cwd '/tmp'
  code <<-EOH
    add-apt-repository ppa:formorer/icinga
  	apt-get update
  EOH
end

node[:icinga2][:base_pkgs].each do |pkg|
	package pkg do
	  action :install
	end
end

#########################
# Setup icinga2 database
#########################

# prepare sql file for database creation
template '/tmp/icingadb_setup.sql' do
  source 'icingadb_setup.sql.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

# create database
execute 'icinga database setup' do
  command 'mysql -u root < /tmp/icingadb_setup.sql'
  action
end

# load tablespace
execute 'load ido-mysql schema' do
  command 'mysql -u root icinga < /usr/share/icinga2-ido-mysql/schema/mysql.sql'
  action :run
end

############################
# Reset mysql root password
############################

template '/tmp/reset_root_password.sql' do
  source 'reset_root_password.sql.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

execute 'reset mysql root password' do
  command 'mysql -u root < /tmp/reset_root_password.sql'
  action
end

# remove temp sql files
execute 'remove tmp sql files' do
  command 'rm -f /tmp/*.sql'
  action :run
end

############################
# Enable additional modules
############################

# ido-mysql
execute 'enable ido-mysql' do
  command 'icinga2 feature enable ido-mysql'
  action :run
end

# update config file and adapter configs
template '/etc/icinga2/features-enabled/ido-mysql.conf' do
  source 'ido-mysql.conf.erb'
  owner 'root'
  group 'root'
  mode '0755'
end

# command
execute 'enable icinga2 command' do
  command 'icinga2 feature enable command'
  action :run
end

##########################
# Restart icinga2 service
##########################

service 'icinga2' do
  action :restart
end

log 'Icinga2 succesfully installed.'
