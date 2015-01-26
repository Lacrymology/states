#!/bin/bash
# {{ salt['pillar.get']('message_do_not_modify') }}
set -e
# Use of this source code is governed by a BSD license that can be
# found in the doc/license.rst file.
#
# Author: Bruno Clermont <bruno@robotinfra.com>
# Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>

# TODO: rewrite in Python
if [ -d /root/salt/states/salt/minion ]; then
    LOCAL_MODE=1
else
    LOCAL_MODE=0
fi

if [ -z "$1" ]; then
    echo "Usage: bootstrap.sh minion-id"
    exit 1
fi
if [ $LOCAL_MODE -eq 0 ] && [ -z "$2" ]; then
    echo "Usage: bootstrap.sh minion-id master-host-or-addr"
    exit 1
fi

# some modules/states require HOME environment variable
# force HOME to be root's home folder
# so we don't have to use -H when using sudo
export HOME=$(grep ^root: /etc/passwd | cut -d ':' -f 6)

apt-get update
apt-get install -y --no-install-recommends python-software-properties python-pip
pip install requests==2.4.3 raven==4.1.1
echo "deb http://archive.robotinfra.com/mirror/salt/2014.1.10-1/ `lsb_release -c -s` main" > /etc/apt/sources.list.d/saltstack-salt-`lsb_release -c -s`.list
apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 0E27C0A6
apt-get update
apt-get install -y --force-yes salt-minion
# end of section

if [ $LOCAL_MODE -eq 1 ]; then
    echo "Salt master-less (local) mode"
    echo $1 > /etc/hostname
    hostname `cat /etc/hostname`
    echo """master: 127.0.0.1
id: $1
mysql.default_file: '/etc/mysql/debian.cnf'
file_log_level: debug
file_client: local
file_roots:
  base:
    - /root/salt/states
pillar_roots:
  base:
    - /root/salt/pillar""" > /etc/salt/minion

    salt-call state.sls salt.patch_salt
    restart salt-minion
    salt-call saltutil.sync_all
else
    echo """id: $1
log_level: debug
master: $2""" > /etc/salt/minion
    restart salt-minion
    salt-call state.sls salt.patch_salt
    restart salt-minion
fi
