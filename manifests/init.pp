# Class: ipaclient
# ===========================
#
# Full description of class ipaclient here.
#
# Parameters
# ----------
#
# [*realm*]
#   String. Name of your FreeIPA realm
#   Default: REALM.COM
#
# [*domain*]
#  String.  DNS Domain to service by SSSD
#  Default: dnsdomain.com
#
# [*trustedrealm*]
#   String. Optional, name of a trusted AD realm
#   Default: AD.REALM.COM
#
# [*trusteddomain*]
#  String.  Optional, name of a trusted AD DNS Domain
#  Default: ad.dnsdomain.com
#
# [*suffix*]
#   String.  LDAP base to search for LDAP results in
#   Default: dc=example,dc=org
#
# [*ldapservers*]
#   String.  LDAP servers to connect to for results.  Comma separated list of hosts.
#   Default: myldapserver.dnsdomain.com
#
# [*sudobindpw*]
#   String.  Password for libnss to connect to ldap server as
#   uid=sudo,cn=sysaccounts,cn=etc,$suffix. Required on CentOS 5
#   Default: true
#
# [*is_ipa_server*]
#   Boolean.  Set to true when SSSD is running on an IPA server
#   Default: false
#
# [*k5loginusers*]
#   String. List of principals authorized to login as root on the host
#   Default: admin@REALM.COM
#
# Examples
# --------
#
# @example
#    class { 'ipaclient':
#        realm        => 'MYREALM.COM',
#        ldapservers  => ['ldap1.mycompany.com, 'ldap2.mycompany.com'],
#    }
#
# Authors
# -------
#
# Loris Santamaria <loris@lgs.com.ve>
#
# Copyright
# ---------
#
# Copyright 2016 Loris Santamaria.
#
class ipaclient (
  $realm          = 'REALM.COM',
  $domain         = 'dnsdomain.com',
  $trustedrealm   = 'AD.REALM.COM',
  $trusteddomain  = 'ad.dnsdomain.com',
  $k5loginusers   = 'admin@REALM.COM',
  $suffix         = 'dc=example,dc=com',
  $ldapservers    = 'myldapserver.dnsdomain.com',
  $sudobindpw     = 'eituyuiijjfdhfvjliooiutgy678',
  $is_ipa_server  = 'no'
){
  $has_sssd_dbus = $::lsbmajdistrelease ? {
    '5'     => absent,
    default => present,
  }
  package {
    'ipa-client':
        ensure => present;
    'openldap-clients':
        ensure => present;
    'krb5-workstation':
        ensure => present;
    'cyrus-sasl-gssapi':
        ensure => present;
    'sssd':
        ensure => present;
    'sssd-dbus':
        ensure => $has_sssd_dbus;
    'sudo':
        ensure => present;
  }
  file {
    '/etc/nss_ldap.conf':
        content => template('directorio/nss_ldap.conf.erb');
    '/etc/ldap.conf':
        ensure  => link,
        target  => '/etc/nss_ldap.conf',
        require => File['/etc/nss_ldap.conf'];
    '/etc/openldap/ldap.conf':
        content => template('directorio/ldap.conf.erb'),
        require => Package['openldap-clients'];
    '/etc/krb5.conf':
        content => template('directorio/krb5.conf.erb'),
        require => Package['krb5-workstation'];
    '/etc/sssd/sssd.conf':
        content => template('directorio/sssd.conf.erb'),
        owner   => 'root',
        group   => 'root',
        mode    => '0600',
        require => [ Package['sssd'], Package['sssd-dbus'] ];
    '/etc/nsswitch.conf':
        content => template('directorio/nsswitch.conf.erb'),
        require => Package['ipa-client'];
    '/root/.k5login':
        mode    => '0600',
        seltype => 'krb5_home_t',
        seluser => 'unconfined_u',
        require => K5login['/root/.k5login'];
  }
  k5login {
    '/root/.k5login':
        mode       => '600',
        principals => [ $k5loginusers ];
  }
  service {
    'sssd':
        ensure    => running,
        enable    => true,
        require   => File['/etc/sssd/sssd.conf'],
        subscribe => File['/etc/sssd/sssd.conf'];
  }
}
