#!/bin/bash

apt-get install -o DPkg::Options::=--force-confold -o DPkg::Options::=--force-confdef -y python-pip python-psutil
pip install http://archive.robotinfra.com/mirror/unittest-xml-reporting-a4d6593eb9b85996021285cc2ca3830701fcfe9b.tar.gz
apt-get install -o DPkg::Options::=--force-confold -o DPkg::Options::=--force-confdef -y salt-minion
restart salt-minion || true
