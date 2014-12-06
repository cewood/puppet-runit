class runit (
  $service_dir  = $runit::params::service_dir,
  $service_src  = $runit::params::service_src,
  $log_basedir  = $runit::params::log_basedir,
) inherits runit::params {

  class { '::runit::install': }
  #class { '::runit::config': }
  class { '::runit::service': }

  anchor {
    'runit::before':
      before  => Class['::runit::install'],
      notify  => Class['::runit::service'];
    'runit::after':
      require => Class['::runit::service'];
  }
}
