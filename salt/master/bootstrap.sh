#!/bin/bash
# {{ salt['pillar.get']('message_do_not_modify') }}
set -e
# Use of this source code is governed by a BSD license that can be
# found in the doc/license.rst file.
#
# Author: Bruno Clermont <bruno@robotinfra.com>
# Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>

if [ -z "$1" ]; then
    echo "Missing argument: minion id"
    exit 1
fi

/root/salt/states/salt/minion/bootstrap.sh $1

salt-call state.highstate
