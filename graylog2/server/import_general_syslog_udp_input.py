#!/usr/bin/python2
# -*- coding: utf-8 -*-

# Copyright (c) 2014, Diep Pham
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
# FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
# COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
# INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
# BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
# ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

"""
Auto create General Syslog UDP input
"""

__author__ = 'Diep Pham'
__maintainer__ = 'Diep Pham'
__email__ = 'favadi@robotinfra.com'

from pymongo import Connection
import datetime
import logging
import subprocess
import sys
import time
import uuid

import pysc


logger = logging.getLogger(__name__)

@pysc.profile(log=logger)
def main():
    if len(sys.argv) <= 1:
        logger.error('need exactly one argument: db_name')
        sys.exit(1)

    # create the collection object
    db_name = sys.argv[1]
    connection = Connection()
    db = connection[db_name]
    inputs_collection = db['inputs']

    general_udp_input = {
        "title": "General Syslog UDP",
        "global": True,
        "created_at": datetime.datetime.now(),
        "input_id": str(uuid.uuid4()),
        "configuration": {
            "port": 1514,
            "allow_override_date": True,
            "store_full_message": True,
            "bind_address": "0.0.0.0",
            "recv_buffer_size": 1048576
        },
        "creator_user_id": "admin",
        "type": "org.graylog2.inputs.syslog.udp.SyslogUDPInput"
    }

    if not inputs_collection.find_one({"title": "General Syslog UDP"}):
        # insert general syslog input object
        inputs_collection.insert(general_udp_input)

        # restart mongodb
        try:
            subprocess.check_output(['restart', 'graylog2-server'])
            time.sleep(15)
        except subprocess.CalledProcessError as err:
            logger.error(err.output)
            sys.exit(1)

if __name__ == '__main__':
    main()
