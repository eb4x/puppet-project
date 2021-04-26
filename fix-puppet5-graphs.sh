#!/usr/bin/env bash
mkdir -p ${HOME}/src
git clone -b 5.5.x https://github.com/puppetlabs/puppet.git ${HOME}/src/puppet
cd ${HOME}/src/puppet
git cherry-pick b8f9407e61fec68106d2258e0ab23d12cc468d29

sudo cp lib/puppet/external/dot.rb /opt/puppetlabs/puppet/lib/ruby/vendor_ruby/puppet/external/dot.rb 
sudo cp lib/puppet/graph/simple_graph.rb /opt/puppetlabs/puppet/lib/ruby/vendor_ruby/puppet/graph/simple_graph.rb

