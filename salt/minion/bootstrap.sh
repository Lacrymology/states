#!/bin/sh

if [ -z "$1" ]; then
    echo "Missing argument: minion id"
    exit 1
fi

export HOME=/root

apt-get update
apt-get install -y python-software-properties
if [ "`lsb_release -r -s`" = "10.04" ]; then
    apt-add-repository ppa:saltstack/salt
else
    apt-add-repository -y ppa:saltstack/salt
fi
apt-get update
apt-get install -y salt-minion

cp /root/salt/states/salt/minion/bootstrap.conf /etc/salt/minion
echo "id: $1" >> /etc/salt/minion
restart salt-minion

salt-call saltutil.sync_all
