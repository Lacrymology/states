#!/bin/sh

export HOME=/root

apt-add-repository -y ppa:saltstack/salt
apt-get update
apt-get install -y salt-minion

salt-call -l all --local saltutil.sync_all
salt-call -l all --local state.sls salt.master

find /srv/salt ! -name top.sls -delete
