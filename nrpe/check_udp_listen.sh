#!/bin/bash

# Use of this is governed by a license that can be found in doc/license.rst.

# Author: Diep Pham <favadi@robotinfra.com>
# Maintainer: Diep Pham <favadi@robotinfra.com>

# Nagios plugin for checking if a UDP port is listen on localhost
#
# require:
#   - ss

set -o errexit

# log start stop time to syslog
source /usr/local/share/salt_common.sh
log_start_script "$@"
trap "log_stop_script \$?" EXIT

readonly STATE_OK=0
readonly STATE_WARNING=1
readonly STATE_CRITICAL=2
readonly STATE_UNKNOWN=3

# require UDP port
if [[ -z "$1" ]]; then
    echo "usage: $0 <port>"
    exit "$STATE_UNKNOWN"
elif [[ ! "$1" =~ ^[0-9]+$ ]]; then  # "$1" is not a number
    echo "Invalid port: $1/UDP."
    exit "$STATE_UNKNOWN"
fi

port="$1"

# get list of listening UDP ports
listen_ports=($(ss -nlu | awk 'NR >= 2 {sub(/^.*:/, "", $4); print $4}'))

found=0  # not found
for listen_port in "${listen_ports[@]}"; do
    if [[ "$listen_port" -eq  "$port" ]]; then
        found=1  # found
        break
    fi
done

if [[ "$found" -eq 0 ]]; then  # not found
    echo "${port}/UDP CRITICAL"
    exit "$STATE_CRITICAL"
fi

echo "${port}/UDP OK"
exit "$STATE_OK"
