#!/bin/sh

if [ -z "$1" ]; then
    echo "Missing argument: minion id"
    exit 1
fi

export HOME=/root

apt-add-repository -y ppa:saltstack/salt
apt-get update
apt-get install -y salt-minion

salt-call -l all --local saltutil.sync_all

echo "log_level: debug" > /etc/salt/minion
echo "id: $1" >> /etc/salt/minion

salt-call -l all --local state.highstate

echo "If everthing went fine, please run 'find /srv/salt ! -name top.sls -delete'"
