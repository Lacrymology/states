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

# Run a full scan on / except some directories ( /sys, /dev, /proc, /run)

# limit resources usage
renice -n 19 -p $$ > /dev/null
ionice -c idle -p $$

# safe guard
set -o nounset
set -o errexit
set -o pipefail

readonly status_file=/var/lib/clamav/last-scan

# log start stop time to syslog
source /usr/local/share/salt_common.sh
# Ensure that only one instance of this script is running at a time
locking_script
log_start_script "$@"
trap "log_stop_script \$?" EXIT

exclude_list=('sys' 'dev' 'proc' 'run')

exclude_string=""
for exclude in "${exclude_list[@]}"; do
    exclude_string="$exclude_string""! -name $exclude "
done

scan_list=$(find / -maxdepth 1 -mindepth 1 $exclude_string | xargs)

retval=""
clamdscan --fdpass --quiet $scan_list | logger -t clamdscan -p local0.info; \
    retval="$?" || true

case "$retval" in
    0 )  # no virus found
        touch "$status_file"
        exit 0 ;;
    1 )  # virus(es) found
        echo 'Virus(es) found!' | logger -t clamdscan -p local0.error
        exit 1 ;;
    2 )  # an error occured
        echo 'An error occured!' | logger -t clamdscan -p local0.error
        exit 2 ;;
esac
