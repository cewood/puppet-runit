# A define to create a runit service/run script, as
#  distinct from the runit::service which is to
#  ensure that runsvdir is started with parent pid
#  set to process 1 (init).

define runit::run (
  $command,
  $shell = '/bin/bash',
  $down = undef,
  $finish_shell = '/bin/bash',
  $finish_command = undef,
  $log_command = "svlogd -tt /var/log/service/${name}",
  $log_config = true,
  $log_shell = '/bin/sh',
) {
  anchor {
    "runit::run::${name}::before":
      before  => File["/var/log/service/${name}"];
    "runit::run::${name}::after":
      require => File['/etc/service/someservice'];
  }

  file {
    "/var/lib/service/${name}":
      ensure  => directory,
      require => Anchor["runit::run::${name}::before"],
      before  => Anchor["runit::run::${name}::after"];
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
    "/etc/service/${name}":
      ensure  => link,
      target  => "/var/lib/service/${name}",
      require => File["/var/lib/service/${name}/run"];
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
      require => File["/var/lib/service/${name}/log"];
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
