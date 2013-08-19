#!/bin/sh

if [ -z "$1" ]; then
    echo "Missing argument: minion id"
    exit 1
fi

/root/salt/states/salt/minion/bootstrap.sh $1

salt-call state.highstate
