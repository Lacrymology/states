#!/bin/sh

mkdir -p /etc/salt/pki/minion
chmod 700 /etc/salt/pki/minion
mv /tmp/minion /etc/salt/
mv /tmp/minion.pub /etc/salt/pki/minion/
mv /tmp/minion.pem /etc/salt/pki/minion/
chmod 400 /etc/salt/pki/minion/minion.pem

# if you change the following section, please also change
# salt/minion/bootstrap.sh
apt-get install -y python-software-properties
apt-add-repository -y ppa:saltstack/salt
echo "deb http://saltinwound.org/ubuntu/0.15.3/ `lsb_release -c -s` main" > /etc/apt/sources.list.d/saltstack-salt-`lsb_release -c -s`.list
apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 0E27C0A6
apt-get update
apt-get install -y --force-yes -o DPkg::Options::=--force-confold salt-minion
salt-call saltutil.sync_all
