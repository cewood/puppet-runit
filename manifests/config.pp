# Configure anything before we insstall and start runit
class runit::config {
  anchor {
    'runit::config::begin':
      before => Anchor['runit::config::end'];
    'runit::config::end':
      require => Anchor['runit::config::begin'];
  }

  # Make sure our dependant folders exist already
  file {
    '/etc/service':
      ensure  => directory,
      mode    => '0755',
      require => Anchor['runit::config::begin'],
      before  => Anchor['runit::config::end'];
    '/var/lib/service':
      ensure  => directory,
      mode    => '0755',
      require => Anchor['runit::config::begin'],
      before  => Anchor['runit::config::end'];
    '/var/log/service':
      ensure  => directory,
      mode    => '0755',
      require => Anchor['runit::config::begin'],
      before  => Anchor['runit::config::end'];
  }
}
