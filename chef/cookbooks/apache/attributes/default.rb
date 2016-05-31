#
# Cookbook Name:: apache
# File:: default
#
# Copyright (c) 2016 Daniel Costa, All Rights Reserved.
#
# Description: Apache cookbook attributes file
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


default[:apache][:httpd][:install_path] = "/etc/apache2"
default[:apache][:httpd][:httpd_install] = "/var/www"
default[:apache][:httpd][:httpd_user] = "www-data"
default[:apache][:httpd][:httpd_userpw] = "$1$qnp6.xPP$y2l4Gl7e8yKi/1pkndlfA/"
default[:apache][:httpd][:httpd_group] = "www-data"
default[:apache][:httpd][:httpd_server_name] = "localhost"
default[:apache][:httpd][:httpd_error_log] 	= "logs/access_log"
default[:apache][:httpd][:httpd_access_log] = "logs/error_log"
default[:apache][:httpd][:httpd_server_adm] = "webmaster@localhost"
default[:apache][:httpd][:httpd_port] = 8080
default[:apache][:httpd][:conf_path] = "#{node[:apache][:httpd][:install_path]}/sites-available"


default[:apache][:httpd][:pkgs_x86_64] = [ 'gcc-c++', 'libgcj', 'glibc-devel']
default[:apache][:httpd][:pkgs_i686] = [ 'glibc-devel', 'unixODBC', 'unixODBC-devel', 'libgcc' ]