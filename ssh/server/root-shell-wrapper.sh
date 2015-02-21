#!/bin/bash
# {{ salt['pillar.get']('message_do_not_modify') }}
# Use of this is governed by a license that can be found in doc/license.rst.

# A shell wrapper that log real human name to syslog

# exit on error
set -e

readonly user_name="$1"
readonly shell_name="$SHELL"

# write user name to syslog
logger -t sshd "root user log in (${user_name})"

if [[ -z "$SSH_ORIGINAL_COMMAND" ]];  then
    $SHELL --login
else
    eval "$SSH_ORIGINAL_COMMAND"
fi
