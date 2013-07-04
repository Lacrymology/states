#!/bin/sh

if [ -z "$1" ]; then
    echo "Missing argument: minion id"
    exit 1
fi

export HOME=/root

apt-get install -y python-software-properties
apt-add-repository -y ppa:saltstack/salt

echo "deb http://saltinwound.org/ubuntu/0.15.3/ `lsb_release -c -s` main" > /etc/apt/sources.list.d/saltstack-salt-`lsb_release -c -s`.list
apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 0E27C0A6
apt-get update
apt-get install -y --force-yes salt-minion

cp /root/salt/states/salt/minion/bootstrap.conf /etc/salt/minion
echo "id: $1" >> /etc/salt/minion
restart salt-minion

salt-call saltutil.sync_all
