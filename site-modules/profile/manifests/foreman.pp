class profile::foreman(
  Hash $config1 = $profile::foreman::config1,
) {

  class { '::foreman::repo':
    repo => '2.5',
  }

  class { '::puppet':
    server => true,
    server_external_nodes => '',
  }

  include ::foreman

  include ::foreman::cli
  Class['foreman::cli'] <-
  Class['foreman::repo']

  foreman::cli::plugin { 'foreman':
    require => Class['foreman::repo'],
    version => 'latest',
  }
  foreman::cli::plugin { 'foreman_templates':
    require => Class['foreman::repo'],
    version => 'latest',
  }

  include ::foreman::compute::libvirt

  include ::foreman::plugin::discovery
  include ::foreman::plugin::hooks
  include ::foreman::plugin::templates
  Foreman::Plugin <| |> <-
  Class['foreman::repo']

  include ::foreman_proxy
  Class['foreman_proxy'] <-
  Class['foreman::repo']

  # temporary fix, https://github.com/theforeman/puppet-foreman_proxy/pull/719
  Class['foreman_proxy::proxydhcp'] <-
  User['foreman-proxy']

  include ::foreman_proxy::plugin::discovery

  case $::osfamily {
    'RedHat': {
      case $::operatingsystemmajrelease {
        '8': {
          firewalld_service { 'RH Satellite 6':
            ensure => 'present',
            service => 'RH-Satellite-6',
            zone => 'public',
          }
        }
        '7': {
          firewalld_service { 'RH Satellite 6 capsule':
            ensure => 'present',
            service => 'RH-Satellite-6-capsule',
            zone => 'public',
          }
        }
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
