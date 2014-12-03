define runit::user (
  $basedir = $runit::basedir,
  $logdir  = $runit::logdir,
  $group   = undef,
  $home    = $runit::home,
) {
  $_user = $title
  if $basedir == undef {
    $_basedir = "${home}/${_user}"
  }
  else {
    $_basedir = $basedir
  }
  if $logdir == undef {
    $_logdir = "${basedir}/logs"
  }
  else {
    $_logdir = $logdir
  }
  if $group == undef {
    $_group = $_user
  }
  else {
    $_group = $group
  }
  User {
    owner   => root,
    group   => root,
  }
  file { "/etc/runit/${_user}":
    ensure  => directory,
    mode    => '0755',
  }
  file { "/etc/runit/${_user}/down":
    ensure  => absent,
  }
  file { "/etc/runit/${_user}/run":
    ensure  => file,
    mode    => '0555',
    content => template('runit/user/run.erb'),
  }
  file { "/etc/runit/${_user}/log":
    ensure  => directory,
    mode    => '0755',
    require => File["/etc/runit/${_user}"],
  }
  file { "/etc/runit/${_user}/log/down":
    ensure  => absent,
    require => File["/etc/runit/${_user}/log"],
  }
  file { "/etc/runit/${_user}/log/run":
    ensure  => file,
    mode    => '0555',
    content => template('runit/user/log_run.erb'),
    require => File[
      "/etc/runit/${_user}/log",
      "/etc/runit/${_user}/log/down",
      "${_logdir}/runsvdir"
    ],
  }

  file { "${_basedir}/service":
    ensure  => directory,
    mode    => '0755',
    owner   => $_user,
    group   => $_group,
  }
  file { "${_basedir}/runit":
    ensure  => directory,
    mode    => '0755',
    owner   => $_user,
    group   => $_group,
  }
  if ! defined(File[$logdir]) {
    file { $_logdir:
      ensure  => directory,
      mode    => '0755',
      owner   => $_user,
      group   => $_group,
    }
  }
  file { "${_logdir}/runsvdir":
    ensure  => directory,
    mode    => '0755',
    owner   => $_user,
    group   => $_group,
    require => File[$_logdir],
  }

  if ! defined(File['/etc/service']) {
    file { '/etc/service':
      ensure   => directory,
    }
  }
  file { "/etc/service/${_user}":
    ensure   => link,
    target   => "/etc/runit/${_user}",
    require  => File['/etc/service', "/etc/runit/${_user}/run"],
  }
  $var = "export SVDIR='${_basedir}/service'"
  exec { "runit-update-${_user}-bash-profile":
    command => "/bin/echo ${var} >> ~${_user}/.bash_profile",
    user    => $_user,
    group   => $_group,
    unless  => "/bin/grep -w '${var}' ~${_user}/.bash_profile",
  }
}
