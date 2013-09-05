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
}
