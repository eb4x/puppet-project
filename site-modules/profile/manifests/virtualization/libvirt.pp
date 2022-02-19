class profile::virtualization::libvirt(
  Boolean $manage_firewall = true,
) {
  include ::libvirt

  if $manage_firewall {
    firewalld_custom_service { 'libvirt-gfx':
      ensure => 'present',
      short  => 'Virtual Machine Management (GFX)',
      ports  => [
        {
          'port'     => '5900-5999',
          'protocol' => 'tcp',
        },
      ],
    }

    firewalld_service { 'Virtual Machine Management (GFX)':
      ensure  => 'present',
      service => 'libvirt-gfx',
      zone    => 'public',
    }

    firewalld_service { 'Virtual Machine Management':
      ensure  => 'present',
      service => 'libvirt',
    }

    firewalld_service { 'Virtual Machine Management (TLS)':
      ensure  => 'present',
      service => 'libvirt-tls',
    }
  }
}
