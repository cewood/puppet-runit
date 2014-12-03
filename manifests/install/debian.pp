class runit::install::debian (
) {
  # Class to install runit on debian family systems
  package { 'runit':
    ensure   => installed;
  }
}
