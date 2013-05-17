#!/bin/sh

if [ -z "$1" ]; then
    echo "Missing argument: minion id"
    exit 1
fi

export HOME=/root

apt-add-repository -y ppa:saltstack/salt
apt-get update
apt-get install -y salt-minion

echo "log_level: debug" > /etc/salt/minion
echo "file_client: local" >> /etc/salt/minion
echo "id: $1" >> /etc/salt/minion

restart salt-minion
