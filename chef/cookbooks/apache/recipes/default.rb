#
# Cookbook Name:: apache
# Recipe:: default
#
# Copyright (c) 2016 Daniel Costa, All Rights Reserved.
#
# Description: Install Apache HTTPD Server
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

httpd_conf = node[:apache][:httpd][:conf_path] + "/httpd.conf"

#########################
# Install httpd package.
#########################

package 'httpd' do
  action :install
end

############################
# Customize server instance.
############################

template httpd_conf do
  source "httpd.conf.erb"
  action :touch
  owner node[:apache][:httpd][:httpd_user]
  group node[:apache][:httpd][:httpd_group]
  mode 0655
  variables({
    :apache_install_path => node[:apache][:httpd][:install_path],
    :httpd_server_root => node[:apache][:httpd][:httpd_install],
    :httpd_user => node[:apache][:httpd][:httpd_user],
    :httpd_group => node[:apache][:httpd][:httpd_group],
    :httpd_server_name => node[:apache][:httpd][:httpd_server_name],
    :httpd_error_log => node[:apache][:httpd][:httpd_error_log],
    :httpd_access_log => node[:apache][:httpd][:httpd_access_log],
    :httpd_port => node[:apache][:httpd][:httpd_port],
    :httpd_server_adm => node[:apache][:httpd][:httpd_server_adm]
  })
end

#########################
# Enable httpd service.
#########################

service 'httpd' do
  action :enable
end

#########################
# Start httpd instance.
#########################

service 'httpd' do
	action :start
end

log 'Apache HTTPD Server succesfully installed.'
