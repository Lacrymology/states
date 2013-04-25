#!/bin/sh

export HOME=/root

apt-add-repository -y ppa:saltstack/salt
apt-get update
apt-get install -y salt-minion

echo '''
file_roots:
  base:
    - /srv/salt/states
pillar_roots:
  base:
    - /srv/salt/pillar
master: 127.0.0.1
''' > /etc/salt/minion

salt-call -l all --local saltutil.sync_all
salt-call -l all --local state.sls salt.master
