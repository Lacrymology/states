#!/bin/bash
# {{ salt['pillar.get']('message_do_not_modify') }}
set -e
# Copyright (c) 2013, Bruno Clermont
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice, this
#    list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
# ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
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

# force HOME to be root user one
export HOME=`cat /etc/passwd | grep ^root\: | cut -d ':' -f 6`

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
    salt-call saltutil.sync_all
else
    echo """id: $1
log_level: debug
master: $2""" > /etc/salt/minion
    restart salt-minion
fi
