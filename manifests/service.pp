class runit::service {
  # This is to ensure that the runit service is running after
  #  using the runit::install class to install it.
  service { 'runsvdir':
    ensure   => running,
    provider => 'service',
    status   => 'pgrep -P 1 -lf runsvdir',
    require  => Class['::runit::install'],
  }
}
