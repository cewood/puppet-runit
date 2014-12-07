# A define to create a runit service/run script, as
#  distinct from the runit::service which is to
#  ensure that runsvdir is started with parent pid
#  set to process 1 (init).

define runit::run (
  $command,
  $symlink               = true,
  $shell                 = '/bin/bash',
  $down                  = undef,
  $finish_shell          = '/bin/bash',
  $finish_command        = undef,
  $log_command           = "svlogd -tt",
  $log_destination       = "/var/log/service/${name}",
  $log_config            = true,
  $log_shell             = '/bin/sh',
  $svlogd_size           = undef,
  $svlogd_max_files      = undef,
  $svlogd_min_files      = undef,
  $svlogd_rotate_timeout = undef,
  $svlogd_processor      = undef,
  $svlogd_retransmit     = undef,
  $svlogd_forward        = undef,
  $svlogd_prefix         = undef,
) {
  anchor {
    "runit::run::${name}::begin":
      require => Class['runit::install'],
      before  => Anchor["runit::run::${name}::end"];
    "runit::run::${name}::end":
      require => Anchor["runit::run::${name}::begin"];
  }

  file {
    "/var/lib/service/${name}":
      ensure  => directory,
      require => Anchor["runit::run::${name}::begin"],
      before  => Anchor["runit::run::${name}::end"];
    "/var/lib/service/${name}/run":
      mode    => '0755',
      ensure  => present,
      content => template('runit/run.erb'),
      require => File["/var/lib/service/${name}"];
    "/var/lib/service/${name}/log":
      ensure => directory,
      require => File["/var/lib/service/${name}"];
    "/var/lib/service/${name}/log/run":
      mode    => '0755',
      ensure  => present,
      content => template('runit/log/run.erb'),
      require => File["/var/lib/service/${name}/log"];
    "${log_destination}":
      ensure  => directory,
      require => File["/var/lib/service/${name}/log"],
      before  => Anchor["runit::run::${name}::end"];
  }

  if $symlink {
    file { "/etc/service/${name}":
      ensure  => link,
      target  => "/var/lib/service/${name}",
      require => File["/var/lib/service/${name}/run"],
      before  => Anchor["runit::run::${name}::end"];
    }
  }

  if $down {
    file { "/var/lib/service/${name}/down":
      ensure  => present,
      content => template('runit/down.erb'),
      require => File["/var/lib/service/${name}"],
      before  => File["/var/lib/service/${name}/run"];
    }
  }

  if $log_config {
    file { "/var/lib/service/${name}/log/config":
      mode    => '0755',
      ensure  => present,
      content => template('runit/log/config.erb'),
      require => File["/var/lib/service/${name}/log"],
      before  => File["/var/lib/service/${name}/run"];
    }
  }

  if $finish_command {
    file { "/var/lib/service/${name}/finish":
      mode    => '0755',
      ensure  => present,
      content => template('runit/finish.erb'),
      require => File["/var/lib/service/${name}"],
      before  => File["/var/lib/service/${name}/run"];
    }
  }
}
