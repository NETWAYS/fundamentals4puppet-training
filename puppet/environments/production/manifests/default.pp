node 'puppet.localdomain' {

  class { 'yum':
    keep_kernel_devel => false,
    clean_old_kernels => true,
    config_options => {
      deltarpm => 0,
    }
  }

  file { '/etc/systemd/system/puppetmaster.service':
    ensure => file,
    mode   => '0755',
    content => '# service unit for puppetmaster with webrick
[Unit]
Description=Puppet master
Wants=basic.target
After=basic.target network.target

[Service]
EnvironmentFile=-/etc/sysconfig/puppetagent
EnvironmentFile=-/etc/sysconfig/puppet
EnvironmentFile=-/etc/default/puppet
ExecStart=/opt/puppetlabs/puppet/bin/puppet master $PUPPET_EXTRA_OPTS --no-daemonize
ExecReload=/bin/kill -HUP $MAINPID
KillMode=process

[Install]
WantedBy=multi-user.target'
  }

  ~> exec { 'puppetmaster-systemd-reload':
    path        => '/bin:/usr/bin',
    command     => 'systemctl daemon-reload',
    refreshonly => true,
  }

  user { 'git':
    ensure     => present,
    home       => '/home/git',
    managehome => true,
  }

   ssh_authorized_key { 'training@agent':
      ensure => present,
      user   => 'git',
      type   => 'ssh-rsa',
      key    => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQD3lYc4I617lXh8lAz5k7B/bnH1gceZ85Un50UBP78gvymSVT6q7CBrSDqyH+n0Bso7zHQX5p3BbmFiIuWq5jskJ/6qc53LLuzO3Mi4h2SwEwhXnlnst1bgvkxNwH6rLpd3W+48j+jnYwb0YOIxldZb67MZPUT7bplMwWTMaWKz1i5qIWK2nTmJkSAp5vWFAorsl6fa+DtC8Id3pbt54TUxjA6L7bZ9xYma2SNav0YQsc4WFtCUZz5/uSSRlYQMFO5DwwIjSN4mXGmxHCtI+3WmMDXE1KUJ5S5ifC01qP9Js7YCP0qyMJTai39T++0NYZXjVpWyos9DOnuK9Y6i/Wi7',
  }

  package { 'ruby':
    ensure => installed,
  }
 
  class { '::puppet':
    server                        => true,
    server_implementation         => 'master',
    server_package                => 'puppetserver',
#    dns_alt_names                 => [ 'puppet' ],
    server_passenger              => false,
    server_service_fallback       => true,
    agent                         => true,
    server_foreman                => false,
    server_external_nodes         => '',
    vardir                        => '/opt/puppetlabs/server/data/puppetserver',
    server_directory_environments => true,
    server_dynamic_environments   => false,
    server_environments           => [ 'production' ],
    server_reports                => 'store',
    server_git_repo               => true,
    server_environments_owner     => 'git',
    server_environments_group     => 'puppet',
    server_environments_mode      => '0755',
    server_git_repo_user          => 'git',
    server_git_repo_path          => '/home/git/puppet.git',
    server_git_branch_map         => { 'master' => 'production' },
  }

  exec { 'remove-production-non-git':
    path    => '/bin',
    command => 'rm -rf /etc/puppetlabs/code/environments/production',
    creates => '/etc/puppetlabs/code/environments/production/.git',
    require => Class['puppet'],
  }
  ~> exec { 'git-clone-production':
    path        => '/bin',
    cwd         => '/etc/puppetlabs/code/environments',
    command     => 'git clone /home/git/puppet.git production',
    user        => 'git',
    group       => 'git',
    refreshonly => true,
  }
}
