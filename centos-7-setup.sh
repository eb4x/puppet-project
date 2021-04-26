#!/usr/bin/env bash

sudo yum install epel-release git

sudo rpm -Uvh https://yum.puppet.com/puppet5-release-el-7.noarch.rpm
sudo yum install -y puppet-agent

sudo /opt/puppetlabs/puppet/bin/gem install r10k
