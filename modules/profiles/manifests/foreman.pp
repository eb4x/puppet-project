class profiles::foreman {

  class { '::foreman::repo':
    repo => '2.3',
  }

  class { '::puppet':
    server => true,
  }

  include ::foreman
}
