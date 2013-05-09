#!/bin/sh

export HOME=/root

apt-add-repository -y ppa:saltstack/salt
apt-get update
apt-get install -y salt-minion

salt-call -l all --local saltutil.sync_all

echo "Please edit /etc/salt/minion"
echo "Add a line 'id: hostid' and replace hostid by proper id"
echo "then execute: salt-call -l all --local state.highstate"

#find /srv/salt ! -name top.sls -delete
