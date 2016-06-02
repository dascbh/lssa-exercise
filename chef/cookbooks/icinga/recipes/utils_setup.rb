#
# Cookbook Name:: icinga
# Recipe:: utils_setup
#
# Copyright (c) 2016 Daniel Costa, All Rights Reserved.
#
# Description: Setup utils for OS
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

package 'python-pip' do
  action :install
end

execute 'install awscli pip' do
  command 'pip install awscli --ignore-installed six'
  action :run
end


###################
# Create cron job
###################

# prepare script template
template '/usr/sbin/log_collector' do
  source 'log_collector.erb'
  owner 'root'
  group 'root'
  mode '0755'
end

# create job
cron 'daily_log_collection' do
  minute '0'
  hour '7'
  command '/usr/sbin/log_collector'
  action :create
end

##############################
# Generate AWS CLI config file
##############################

bash 'setup awscli config' do
  user 'root'
  code <<-EOH
	mkdir /root/.aws
	echo "[default]" > /root/.aws/credentials
	echo "aws_access_key_id = AKIAJHH4MD436X35JZYQ" >> /root/.aws/credentials
	echo "aws_secret_access_key = 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" >> /root/.aws/credentials
  EOH
end

execute 'install awscli pip' do
  command 'pip install awscli --ignore-installed six'
  action :run
end
