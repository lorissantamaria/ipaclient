# ipaclient

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Limitations - OS compatibility, etc.](#limitations)
5. [Development - Guide for contributing to the module](#development)

## Overview

This modules configures sssd, krb5.conf, nsswitch.conf and /etc/openldap/ldap.conf
on a FreeIPA client. On CentOS 5 servers it configures also /etc/ldap.conf as it 
is required for sudo support. This module has been tested on CentOS 5/6/7 but 
of course it should work on the corresponding RHEL versions

## Module Description

Generally ipa-client-install is enough to set up a FreeIPA client. However this
module is required if you want to keep your config in sync across multiple hosts, 
plus it adds some extra value like sudo configuration in CentOS 5

## Usage

Join your host to the ipa domain with ipa-client-install, then add this module

<pre>
    class { 'ipaclient':
        realm        => 'MYREALM.COM',
        ldapservers  => ['ldap1.mycompany.com, 'ldap2.mycompany.com'],
    }
</pre>

### What ipaclient affects

* /etc/sssd/sssd.conf
* /etc/nsswitch.conf
* /etc/krb5.conf
* /etc/openldap/ldap.conf
* /etc/nss_ldap.conf

## Limitations

This module is compatible with RHEL and CentOS versions 5/6/7

## Development

* Fork it
* Create a topic branch
* Improve/fix (with spec tests)
* Push new topic branch
* Submit a PR
