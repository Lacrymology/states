#!/bin/bash

# Use of this is governed by a license that can be found in doc/license.rst.

# Author: Diep Pham <favadi@robotinfra.com>
# Maintainer: Diep Pham <favadi@robotinfra.com>
#             Quan Tong Anh <quanta@robotinfra.com>

# Nagios plugin for checking if a UDP port is listen on localhost
#
# require:
#   - netcat-traditional

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
nc.traditional -zu localhost "$port"

if [[ $? -eq 0 ]]; then
    echo "${port}/UDP OK"
    exit "$STATE_OK"
else
    echo "${port}/UDP CRITICAL"
    exit "$STATE_CRITICAL"
fi
