# == Class <%= metadata['name'] %>::install
#
# This class is called from <%= metadata['name'] %> for install.
#
class <%= metadata['name'] %>::install {

  package { $::<%= metadata['name'] %>::package_name:
    ensure => present,
  }
}
