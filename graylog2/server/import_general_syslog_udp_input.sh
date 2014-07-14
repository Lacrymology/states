#!/bin/bash

# Copyright (c) <2014>, <Diep Pham>
# All rights reserved.

# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:

# 1. Redistributions of source code must retain the above copyright
# notice, this list of conditions and the following disclaimer.

# 2. Redistributions in binary form must reproduce the above copyright
# notice, this list of conditions and the following disclaimer in the
# documentation and/or other materials provided with the distribution.

# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
# FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
# COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
# INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
# BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
# ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

# Author: Diep Pham 'favadi@robotinfra.com'
# Maintainer: Diep Pham 'favadi@robotinfra.com'

set -e

readonly db_name="$1"
readonly _TRUE='0'
readonly _FALSE='1'
readonly input_object_json_tmpl=$(cat <<EOF
{
  "title":"General Syslog UDP",
  "global":true,
  "created_at":{
    "\$date":__tmpl:date__
  },
  "configuration":{
    "port":1514,
    "allow_override_date":true,
    "store_full_message":true,
    "bind_address":"0.0.0.0",
    "recv_buffer_size":1048576
  },
  "creator_user_id":"admin",
  "type":"org.graylog2.inputs.syslog.udp.SyslogUDPInput"
}
EOF
)

# check if the input exist in database already
if ! echo 'db.inputs.find({"title": "General Syslog UDP"})' | mongo "${db_name}" | grep '"title" : "General Syslog UDP",'; then
    timestamp="$(date +%s%3N)"
    input_object_json="${input_object_json_tmpl/__tmpl:date__/${timestamp}}"
    echo "${input_object_json}" | mongoimport --db "${db_name}" --collection 'inputs' --jsonArray
    restart graylog2-server
    sleep 15
fi
