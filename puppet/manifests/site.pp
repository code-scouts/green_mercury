node default {
  class { 'nginx': }
  nginx::resource::upstream { 'green_mercury':
    ensure  => present,
    members => [
      'localhost:3000',
    ],
  }

  nginx::resource::vhost { 'green_mercury':
    ensure => present,
    proxy  => 'http://green_mercury',
  }


  include postgresql::server
  postgresql::database_user{'green_mercury':
    password_hash => 'md51fd051de322a3cace927fa654c42935f',
  }

  postgresql::database { 'green_mercury':
    owner => 'green_mercury',
  }

  postgresql::database_grant { 'green_mercury':
    privilege => 'ALL',
    db        => 'green_mercury',
    role      => 'green_mercury',
  }

}
