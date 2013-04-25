#!/bin/sh

apt-add-repository -y ppa:saltstack/salt
apt-get update
apt-get install -y salt-minion

rm -f /etc/salt/minion
touch /etc/salt/minion

echo "Please add the following lines to /etc/salt/minion and run: 'restart salt-minion':"
echo
echo 'master: $IPSALTSERVER'
echo 'id: $HOSTNAME'
echo
