#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Use of this source code is governed by a BSD license that can be
# found in the doc/license.rst file.

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
