class profile::foreman(
  Hash $settings = {},
  Hash $dhcp_classes = {},
  String $initial_admin_password = 'changeme',
  String $db_password = 'changeme',
  String $oauth_consumer_key = 'GjBJNZt3HTkAKQUT9ypGHoWcQMFDzshN',
  String $oauth_consumer_secret = 'tjk92skiejChgsu35uRB3VjsY7fpankt',
) {

  class { '::foreman::repo':
    repo => '2.5',
  }

  class { '::puppet':
    server                => true,
    server_external_nodes => '',
  }

  class { '::foreman':
    version => 'latest',
    plugin_version => 'latest',
    initial_admin_password => $initial_admin_password,
    db_password => $db_password,
    oauth_consumer_key => $oauth_consumer_key,
    oauth_consumer_secret => $oauth_consumer_secret,
  }

  include ::foreman::cli
  Class['foreman::repo']
  -> Class['foreman::cli']

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
  Class['foreman::repo']
  -> Foreman::Plugin <| |>

  $settings.each |$setting, $value| {
    foreman_config_entry { $setting:
      value   => $value,
      require => Class['foreman::database'],
    }
  }

  create_resources('dhcp::dhcp_class', $dhcp_classes)

  include ::foreman_proxy
  Class['foreman::repo']
  -> Class['foreman_proxy']

  # temporary fix, https://github.com/theforeman/puppet-foreman_proxy/pull/719
  User[$foreman_proxy::user]
  -> Class['foreman_proxy::proxydhcp']

  include ::foreman_proxy::plugin::discovery

  case $::osfamily {
    'RedHat': {
      case $::operatingsystemmajrelease {
        '8': {
          firewalld_service { 'RH Satellite 6':
            ensure  => 'present',
            service => 'RH-Satellite-6',
            zone    => 'public',
          }
        }
        '7': {
          firewalld_service { 'RH Satellite 6 capsule':
            ensure  => 'present',
            service => 'RH-Satellite-6-capsule',
            zone    => 'public',
          }
        }
        default: { }
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
