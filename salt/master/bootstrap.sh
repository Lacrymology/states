#!/bin/bash
# {{ salt['pillar.get']('message_do_not_modify') }}
# Use of this is governed by a license that can be found in doc/license.rst.

set -e

if [ -z "$1" ]; then
    echo "Missing argument: minion id"
    exit 1
fi

# some modules/states require HOME environment variable
# force HOME to be root's home folder
# so we don't have to use -H when using sudo
export HOME=$(grep ^root: /etc/passwd | cut -d ':' -f 6)

/root/salt/states/salt/minion/bootstrap.sh $1

# Patch client
rm -f /var/cache/salt/minion/extmods/states/file.py*
salt-call state.sls salt.patch_salt
salt-call saltutil.sync_all

salt-call state.highstate
