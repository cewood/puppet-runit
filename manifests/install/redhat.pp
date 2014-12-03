class runit::install::redhat (
) {
  if ! defined(File[$workspace]) {
    file { $workspace:
      ensure => directory,
      mode   => '0755',
    }
  }
  $package_file = $::runit::package_file
  file { 'runit-rpm':
    ensure  => file,
    path    => "${workspace}/${package_file}",
    source  => "${filestore}/${package_file}",
  }
  package { 'runit':
    ensure   => installed,
    provider => 'rpm',
    source   => "${workspace}/${package_file}",
    require  => File['runit-rpm'],
  }
}
