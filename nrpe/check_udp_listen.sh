#!/bin/bash

# Copyright (c) 2014, Diep Pham
# All rights reserved.

# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:

# 1. Redistributions of source code must retain the above copyright notice, this
#    list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.

# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
# ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

# Author: Van Diep Pham <favadi@robotinfra.com>
# Maintainer: Van Diep Pham <favadi@robotinfra.com>

# Nagios plugin for checking if a UDP port is listen on localhost
#
# require:
#   - netstat

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
listen_ports=($(netstat -nlu | awk 'NR > 2 {sub(/^.*:/, "", $4); print $4}'))

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
