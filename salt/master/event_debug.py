#!/usr/bin/env python
# {{ salt['pillar.get']('message_do_not_modify') }}
# -*- coding: utf-8 -*-
# Use of this is governed by a license that can be found in doc/license.rst.

"""
Log Salt Events, this is obsolete in 2014.7 with salt runner event
"""

import logging
import os
import sys

import pysc

logger = logging.getLogger(__name__)


class SaltDebugEvent(pysc.Application):
    def main(self):
        # defer import to prevent salt to mess with logging
        import salt.syspaths as syspaths
        import salt.config
        import salt.utils.event

        master_conf = os.path.join(syspaths.CONFIG_DIR, 'master')
        opts = salt.config.client_config(master_conf)

        logger.debug("Initailize MasterEvent with %s", opts['sock_dir'])
        event = salt.utils.event.MasterEvent(opts['sock_dir'])

        try:
            for data in event.iter_events(full=True):
                logger.info("Event: %s", data)
        except KeyboardInterrupt:
            sys.exit(0)

if __name__ == '__main__':
    SaltDebugEvent().run()