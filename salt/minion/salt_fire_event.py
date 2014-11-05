#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Copyright (c) 2013, Quan Tong Anh
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice,
#    this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

"""
A script to fire events as non-root user
"""

__author__ = 'Quan Tong Anh'
__maintainer__ = 'Quan Tong Anh'
__email__ = 'quanta@robotinfra.com'

import json
import logging
import os

import pysc

logger = logging.getLogger(__name__)


class SaltFireEvent(pysc.Application):
    def get_argument_parser(self):
        argp = super(SaltFireEvent, self).get_argument_parser()
        argp.add_argument('-p', '--payload', help="The event payload",
                          type=json.loads, required=True)
        argp.add_argument('-t', '--tag', help="The event tag", type=str,
                          required=True)
        return argp

    def main(self):
        payload = self.config['payload']
        tag = self.config['tag']

        import salt.syspaths as syspaths
        import salt.config
        import salt.client
        caller = salt.client.Caller(os.path.join(syspaths.CONFIG_DIR, 'minion'))
        caller.sminion.functions['event.fire_master'](data=payload, tag=tag)
        logger.debug("An event has been fired as '%s': data=%s, tag=%s",
                     os.getenv("SUDO_USER"), payload, tag)


if __name__ == '__main__':
    SaltFireEvent().run()
