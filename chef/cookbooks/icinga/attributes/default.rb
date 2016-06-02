#
# Cookbook Name:: icinga
# File:: default
#
# Copyright (c) 2016 Daniel Costa, All Rights Reserved.
#
# Description: Icinga cookbook attributes file
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

default[:icinga2][:base_pkgs] = [ 'wget', 'icinga2', 'mysql-client', 'mysql-server', 'icinga2-ido-mysql' ]
default[:icinga_web2][:base_pkgs] = [ 'php5', 'php5-cli', 'php5-xmlrpc', 'php5-json', 'php5-xmlrpc', 'php5-gd', 'php5-ldap', 'php5-imagick'
									'php5-pgsql', 'php5-intl', 'php5-common', 'php5-mysql', 'icingaweb2', 'nagios-plugins' ]