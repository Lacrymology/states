#!/bin/sh
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

# if you change the following section, please also change
# salt/cloud/bootstrap.sh
apt-get install -y python-software-properties
apt-add-repository -y ppa:saltstack/salt
echo "deb http://saltinwound.org/ubuntu/0.15.3/ `lsb_release -c -s` main" > /etc/apt/sources.list.d/saltstack-salt-`lsb_release -c -s`.list
apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 0E27C0A6
apt-get update
apt-get install -y --force-yes salt-minion
# end of section

if [ $LOCAL_MODE -eq 1 ]; then
    echo "Salt master-less (local) mode"
    echo $1 > /etc/hostname
    hostname `cat /etc/hostname`
    salt-call saltutil.sync_all
else
    echo """id: $1
log_level: debug
master: $2""" > /etc/salt/minion
    restart salt-minion
fi
