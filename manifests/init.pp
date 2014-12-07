# Installs and configures runit for later use by runit::run
class runit (
  $service_dir  = $runit::params::service_dir,
  $service_src  = $runit::params::service_src,
  $log_basedir  = $runit::params::log_basedir,
) inherits runit::params {
  anchor {
    'runit::begin':
      before => Anchor['runit::end'];
    'runit::end':
      require => Anchor['runit::begin'];
  }

  class {
    '::runit::config':
      require => Anchor['runit::begin'];
    '::runit::install':
      require => Class['runit::config'];
    '::runit::service':
      require => Class['runit::install'],
      before  => Anchor['runit::end'];
  }
}
