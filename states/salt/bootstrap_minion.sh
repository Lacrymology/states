#!/bin/sh

apt-add-repository -y ppa:saltstack/salt
apt-get update
apt-get install -y salt-minion
