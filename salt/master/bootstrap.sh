#!/bin/sh

if [ -z "$1" ]; then
    echo "Missing argument: minion id"
    exit 1
fi

/root/salt/states/salt/minion/bootstrap.sh

salt-call -l all --local saltutil.sync_all
salt-call -l all --local state.highstate

echo "If everthing went fine, please run 'rm -rf /root/salt'"
