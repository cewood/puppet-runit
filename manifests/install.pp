class runit::install {
  anchor { 'nginx::package::begin': }
  anchor { 'nginx::package::end': }

  case $::osfamily {
    'debian': {
      class { '::runit::install::debian': }
    }
    'redhat': {
      class { '::runit::install::redhat': }
    }
    default: {
      case $::operatingsystem {
        'amazon': {
          # Amazon was added to osfamily RedHat in 1.7.2
          # https://github.com/puppetlabs/facter/commit/c12d3b6c557df695a7b2b009da099f6a93c7bd31#lib/facter/osfamily.rb
          warning("Module ${module_name} support for ${::operatingsystem} with facter < 1.7.2 is deprecated")
          warning("Please upgrade from facter ${::facterversion} to >= 1.7.2")
          class { '::runit::install::redhat':
            require => Anchor['runit::install::begin'],
            before  => Anchor['runit::install::end'],
          }
        }
        default: {
          fail("Module ${module_name} is not supported on ${::operatingsystem}")
        }
      }
    }
  }

  # Make sure our dependant folders exist already
  file {
    '/etc/service':
      ensure  => directory,
      mode    => '0755';
    '/var/lib/service':
      ensure  => directory,
      mode    => '0755';
    '/var/log/service':
      ensure  => directory,
      mode    => '0755';
  }
}
