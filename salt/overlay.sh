#!/bin/bash

# create an overlay directory of 2 separated salt states directories
# one ``common`` and the other non-common ``states``
# this is required to works with shared directories between VM and developers
# sandbox

set -e
set -x

mkdir -p /root/salt/states
mount -t overlayfs \
    -o lowerdir=/root/salt/src/common,upperdir=/root/salt/src/states \
    overlayfs /root/salt/states
