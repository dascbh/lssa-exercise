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

user 'icingacmd' do
  action :create
  password '$1$Jgpvs8I0$frhas54j6yKouoFYINrvX/'
end

package 'wget' do
  action :install
end

bash 'install something' do
  user 'root'
  cwd '/tmp'
  code <<-EOH
    add-apt-repository ppa:formorer/icinga
  	apt-get update
  EOH
end

package 'icinga2' do
  action :install
end

package 'mysql-client' do
  action :install
end

package 'icinga2-ido-mysql' do
  action :install
end

execute 'enable ido-mysql' do
  command 'icinga2 feature enable ido-mysql'
  action :run
end

service 'icinga2' do
  action :restart
end

execute 'enable icinga2 command' do
  command 'icinga2 feature enable command'
  action :run
end

service 'icinga2' do
  action :restart
end





