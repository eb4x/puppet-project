#!/usr/bin/env bash


sudo yum install epel-release git vim wget

sudo rpm -Uvh https://yum.puppet.com/puppet5-release-el-7.noarch.rpm
sudo yum install -y puppet-agent

sudo /opt/puppetlabs/puppet/bin/gem install r10k

sudo mkdir -p /etc/puppetlabs/r10k
#vim /etc/puppetlabs/r10k/r10k.yaml
cat <<EOF > /etc/puppetlabs/r10k/r10k.yaml
---
cachedir: '/var/cache/r10k'
#proxy: 'http://proxy.example.com:8000'
sources:
  control-repo:
    remote: 'https://github.com/eb4x/puppet-project.git'
    basedir: '/etc/puppetlabs/code/environments'
EOF
sudo mkdir -p /var/cache/r10k
sudo chown puppet:puppet /var/cache/r10k

# Fix permissions for puppet and install from control-repo
sudo chown puppet:puppet -R /etc/puppetlabs/code/environments
pushd /tmp && sudo --non-interactive --set-home --user=puppet /opt/puppetlabs/puppet/bin/r10k deploy environment production --verbose --puppetfile && popd

# Get PDK
#wget --content-disposition 'https://pm.puppet.com/cgi-bin/pdk_download.cgi?dist=el&rel=7&arch=x86_64&ver=latest'
#sudo yum install ./pdk-*.rpm
