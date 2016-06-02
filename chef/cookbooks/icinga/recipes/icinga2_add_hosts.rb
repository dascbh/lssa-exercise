#
# Cookbook Name:: icinga
# Recipe:: icinga2_add_hosts
#
# Copyright (c) 2016 Daniel Costa, All Rights Reserved.
#
# Description: Add hosts for icinga2 monitoring
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

####################################
# Include hosts (docker containers)
####################################

template '/etc/icinga2/conf.d/hosts.conf' do
  source 'hosts.conf.erb'
  owner 'root'
  group 'root'
  mode '0755'
end

execute 'update node config' do
  command 'icinga2 node update-config'
  action :run
end

service 'icinga2' do
  action :reload
end
