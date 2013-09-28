node default {
  package { "libpq-dev":
    ensure => installed,
  }


  user { 'green_mercury':
    shell => '/bin/bash',
    home => '/home/green_mercury',
    managehome => true,
    ensure => present,
  }

  ssh_authorized_key { 'green_mercury_alorente':
    ensure => present,
    key => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQCkmkuFbxxKmsDiqUMH1X7PFS+EZfR6i7U/Xe0vociH41kA8ZBr6GQ5pXU/MYg8LlOqOnJnxSeScDGMyPMOEida+NsJGYwYHOablAJ9H9cD3uQG9gPZQEYEd8gRCUPwzK9o+80SPAq4YCM8/wttMtEXmqEUVZ5skbQsCEwh5kfsqDNd/b+xXwYYWhr1nPSt8jimvjViXlJ5D7LjoWThFEXztTKTmhOhc6UiKPDeXGsU28A/PuAXgnLQaxjoHk/7IFWFr52yclYo+xGBRb2GBYO6I20sjQK8IHDK5L+f/wufHAoJZsvLj0ekWUwN+NAFLKO8BHqp5XCpblk+V/3JKr6P',
    name => 'green_mercury_alorente',
    type => 'ssh-rsa',
    user => 'green_mercury',
  }

  ssh_authorized_key { 'green_mercury_mrowley':
    ensure => present,
    key => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDGBLN1VUKS+cJCvFEeDGtaVgm4tZ4gKMWHXT2nTXPg5SLQNUZAaqaqBxIUBUhqe0+cTaOVnpnrVnDIZlC2KjPMR3AcSIr7p44M8pPgi2Awy8H5cF9vEK8D/Tkrd8L89XkI/GVTewnB7L8hNK8eN13aHB3dD3du/eZIdp+IgnD2uwY3kqsg4xRRLdu/FtexM4boTl08ABfGTM5H6KBkGP+ISQ0T8u2nF2zoiHDH9706Dw3UETHshRAaqK6elRyUpAEfHML0+w1mK488Hr8lEFUapB0ZYbQGrheTygR8BKcg7MIvxKmJLKM4adCIRrNQpltbc5gTuCuu/Qop/zy4s3J3',
    name => 'green_mercury_mrowley',
    type => 'ssh-rsa',
    user => 'green_mercury',
  }

  file { ['/u', '/u/apps']:
    ensure => 'directory',
    owner => 'root',
    group => 'root',
    mode => '0644'
  }

  file { [
      '/u/apps/green_mercury',
      '/u/apps/green_mercury/shared/',
      '/u/apps/green_mercury/shared/pids',
      '/u/apps/green_mercury/shared/log',
    ]:
    ensure => 'directory',
    owner => 'green_mercury',
    group => 'green_mercury',
    mode => '0644'
  }

  class {'nginx':
    nx_worker_processes => 1,
    nx_worker_connections => 1024,
    nx_client_max_body_size => '4G',
    nx_gzip => 'on',
  }
  nginx::resource::upstream { 'green_mercury':
    ensure => present,
    members => [
      'localhost:3000 weight=1',
    ],
  }
  nginx::resource::location { 'green_mercury':
    ensure => present,
    vhost => 'green-mercury.codescouts.org',
    location => '/',
    match_type => '~',
    proxy => 'http://green_mercury',
    proxy_set_headers => {
      'REMOTE_ADDR' => '$remote_addr',
      'HTTP_HOST' => '$http_host',
    },
  }

  nginx::resource::vhost { 'green-mercury-nonssl.codescouts.org':
    ensure => present,
    server_names => ['green-mercury.codescouts.org'],
    listen_port => 80,
    force_ssl => true,
    www_root => '/u/apps/green_mercury/current/public',
  }

  nginx::resource::vhost { 'green-mercury.codescouts.org':
    ensure => present,
    server_names => ['green-mercury.codescouts.org'],
    listen_port => 443,
    www_root => '/u/apps/green_mercury/current/public',
    ssl => true,
    ssl_cert => '/etc/ssl/server.crt',
    ssl_key => '/etc/ssl/privatekey.pem',
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


  include rvm
  rvm::system_user { green_mercury: ; }

  rvm_system_ruby { 'ruby-1.9.3-p448':
    ensure => 'present',
    default_use => true,
  }

  rvm_gemset {
  "ruby-1.9.3-p448@green_mercury":
    ensure => present,
    require => Rvm_system_ruby['ruby-1.9.3-p448'];
  }
}
