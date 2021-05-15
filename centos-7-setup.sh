#!/usr/bin/env bash

sudo yum install epel-release git

sudo rpm -Uvh https://yum.puppet.com/puppet5-release-el-7.noarch.rpm
sudo yum install -y puppet-agent

sudo /opt/puppetlabs/puppet/bin/gem install r10k

# Get PDK
wget --content-disposition 'https://pm.puppet.com/cgi-bin/pdk_download.cgi?dist=el&rel=7&arch=x86_64&ver=latest'
sudo yum install ./pdk-*.rpm
