class profile::foreman(
  Hash $config1 = $profile::foreman::config1,
) {

  class { '::foreman::repo':
    repo => '2.3',
  }

  class { '::puppet':
    server => true,
  }

  include ::foreman
  include ::foreman::cli
  include ::foreman::compute::libvirt
  include ::foreman::plugin::hooks
  include ::foreman::plugin::discovery
  include ::foreman::plugin::templates
  include ::foreman_proxy

  case $::osfamily {
    'RedHat': {
      firewalld_service { 'http':
        ensure => 'present',
        service => 'http',
        zone => 'public',
      }

      firewalld_service { 'https':
        ensure => 'present',
        service => 'https',
        zone => 'public',
      }
    }
    default: {
      firewall { '190 foreman accept http/https':
        dport => [80, 443],
        proto => 'tcp',
        #action => 'accept',
      }

      firewall { '191 foreman accept dns':
        dport => 53,
        proto => ['tcp', 'udp'],
        #action => 'accept'
      }

      firewall { '192 foreman accept dhcp server':
        dport => 67,
        proto => 'udp',
        #action => 'accept',
      }

      firewall { '193 foreman accept dhcp client':
        chain => 'OUTPUT',
        dport => 68,
        proto => 'udp',
        #action => 'accept',
      }

      firewall { '194 foreman accept tftp':
        dport => 69,
        proto => 'udp',
        #action => 'accept',
      }

      firewall { '195 foreman accept puppet':
        dport => 8140,
        proto => 'tcp',
        #action => 'accept',
      }

      firewall { '196 foreman accept https_proxy':
        dport => 8443,
        proto => 'tcp',
        #action => 'accept',
      }
    }
  }
}
