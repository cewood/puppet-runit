# Ensure that the runit service is running after
#  using the runit::install class to install it.
class runit::service {
  anchor {
    'runit::service::begin':
      before  => Anchor['runit::service::end'];
    'runit::service::end':
      require => Anchor['runit::service::begin'];
  }

  # class { '::runit::service::debian': }

  # case $::osfamily {
  #   'debian': {
  #     class { '::runit::service::debian':
  #       require => Anchor['runit::service::begin'],
  #       before  => Anchor['runit::service::end'];
  #     }
  #   }
  # }

  case $::osfamily {
    'debian': {
      class { '::runit::service::debian':
        require => Anchor['runit::service::begin'],
        before  => Anchor['runit::service::end'];
      }
    }
    'redhat': {
      # Do something here!
    }
    default: {
      case $::operatingsystem {
        'amazon': {
          # Amazon was added to osfamily RedHat in 1.7.2
          # https://github.com/puppetlabs/facter/commit/c12d3b6c557df695a7b2b009da099f6a93c7bd31#lib/facter/osfamily.rb
          warning("Module ${module_name} support for ${::operatingsystem} with facter < 1.7.2 is deprecated")
          warning("Please upgrade from facter ${::facterversion} to >= 1.7.2")
          class { '::runit::service::redhat':
            require => Anchor['runit::service::begin'],
            before  => Anchor['runit::service::end'],
          }
        }
        default: {
          fail("Module ${module_name} is not supported on ${::operatingsystem}")
        }
      }
    }
  }
}
