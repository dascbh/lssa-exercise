#
# Cookbook Name:: icinga
# Recipe:: default
#
# Copyright (c) 2016 Daniel Costa, All Rights Reserved.
#
# Description: Install Icinga Monitoring
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

bash 'setup icingaweb2 repo' do
  user 'root'
  cwd '/tmp'
  code <<-EOH
		wget -O - http://packages.icinga.org/icinga.key | apt-key add -
		echo 'deb http://packages.icinga.org/ubuntu icinga-trusty main' >> /etc/apt/sources.list.d/icinga2.list
		apt-get update
  EOH
end

package 'php5' do
  action :install
end

package 'php5-cli' do
  action :install
end

package 'php5-pear' do
  action :install
end

package 'php5-xmlrpc' do
  action :install
end

package 'php5-json' do
  action :install
end

package 'php5-xmlrpc' do
  action :install
end

package 'php5-gd' do
  action :install
end

package 'php5-ldap' do
  action :install
end

package 'php5-imagick' do
  action :install
end

package 'php5-pgsql' do
  action :install
end

package 'php5-intl' do
  action :install
end

package 'php5-common' do
  action :install
end

package 'php5-mysql' do
  action :install
end

package 'icingaweb2' do
  action :install
end

execute 'change php.ini timezone' do
  command %[sed -i "s/;date.timezone =/date.timezone = 'America\\/New_York'/g" /etc/php5/apache2/php.ini]
  action :run
end

execute 'icingacli token gen' do
  command 'icingacli setup token create'
  action :run
end

execute 'change permissions from /etc/icingaweb2' do
  command 'chmod 0777 /etc/icingaweb2 -R'
  action :run
end


# service 'icinga2' do
#   action :restart
# end

# service 'apache2' do
#   action :restart
# end
