#!/bin/sh
# TODO: rewrite in Python

if [ -d /root/salt/states/salt/minion ]; then
    LOCAL_MODE=1
else
    LOCAL_MODE=0
fi
USAGE="Usage: bootstrap.sh minion-id master-host-or-addr"
CONFIG=/etc/salt/minion

if [ -z "$1" ]; then
    echo "Missing argument Minion ID"
    echo $USAGE
    exit 1
fi
if [ $LOCAL_MODE -eq 0 ] && [ -z "$2" ]; then
    echo "Missing argument Master IP/hostname"
    echo $USAGE
    exit 1
fi

# force HOME to be root user one
export HOME=`cat /etc/passwd | grep ^root\: | cut -d ':' -f 6`

# if you change the following section, please also change
# salt/cloud/bootstrap.sh
apt-get install -y python-software-properties
apt-add-repository -y ppa:saltstack/salt
echo "deb http://saltinwound.org/ubuntu/0.15.3/ `lsb_release -c -s` main" > /etc/apt/sources.list.d/saltstack-salt-`lsb_release -c -s`.list
apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 0E27C0A6
apt-get update
apt-get install -y --force-yes salt-minion
# end of section

# create salt minion config
echo """id: $1
log_level: debug""" > $CONFIG

if [ $LOCAL_MODE -eq 1 ]; then
    echo "Salt master-less (local) mode"
    echo """master: 127.0.0.1
file_client: local
file_roots:
   base:
     - /root/salt/states
pillar_roots:
  base:
    - /root/salt/pillar""" >> $CONFIG
    salt-call saltutil.sync_all
else
    echo "master: $2" >> $CONFIG
    restart salt-minion
fi
