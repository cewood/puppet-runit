# Service class for debian $::osfamily
class runit::service::debian {
  service { 'runsvdir':
    ensure  => running,
    start   => 'telinit q',
    status  => 'pgrep -P 1 -lf runsvdir',
    require => Class['::runit::install'],
  }
}
