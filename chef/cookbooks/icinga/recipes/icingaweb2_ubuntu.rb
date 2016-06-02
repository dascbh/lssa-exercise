#
# Cookbook Name:: icinga
# Recipe:: icingaweb2
#
# Copyright (c) 2016 Daniel Costa, All Rights Reserved.
#
# Description: Install Icinga Web 2 module
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

###########################
# Install required packages
############################

bash 'setup icingaweb2 repo' do
  user 'root'
  cwd '/tmp'
  code <<-EOH
		wget -O - http://packages.icinga.org/icinga.key | apt-key add -
		echo 'deb http://packages.icinga.org/ubuntu icinga-trusty main' >> /etc/apt/sources.list.d/icinga2.list
		apt-get update
  EOH
end

node[:icinga_web2][:base_pkgs].each do |pkg|
	package pkg do
	  action :install
	end
end

#########################
# Update server timezone
#########################

execute 'change php.ini timezone' do
  command %[sed -i "s/;date.timezone =/date.timezone = 'America\\/New_York'/g" /etc/php5/apache2/php.ini]
  action :run
end

###########################
# Generate web app token
############################

execute 'icingacli token gen' do
  command 'icingacli setup token create'
  action :run
end

#######################################
# Change icingaweb2 folder permissions
########################################

execute 'change permissions from /etc/icingaweb2' do
  command 'chmod 0777 /etc/icingaweb2 -R'
  action :run
end

######################
# Restart services
######################

service 'icinga2' do
  action :restart
end

service 'apache2' do
  action :restart
end

log 'Icinga Web2 succesfully installed.'
