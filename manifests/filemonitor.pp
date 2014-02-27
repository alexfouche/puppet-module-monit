# == Class: monit::filemonitor
#
# This module configures a directory to be monitored by Monit
#
# [*path*]            - Path of the dir/file
# [*checks*]          - Array of monit check statements
#
# === Parameters
#
# === Authors
#
#
#
define monit::filemonitor (
  $path,
  $type = 'file',
  $checks = [],
) {
  include monit::params

  validate_string( $path )
  validate_re( $type, '^(file|directory)$' )
  validate_array( $checks )

  if ($checks == []) {
    fail("Missing checks for the ${type} ${name}.")
  }

  file { "${monit::params::conf_dir}/${name}.conf":
    ensure  => $ensure,
    content => template('monit/file.conf.erb'),
    notify  => Service[$monit::params::monit_service],
    require => Package[$monit::params::monit_package],
  }
}
