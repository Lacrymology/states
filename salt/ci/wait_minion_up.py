#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import logging
import datetime

logging.basicConfig(stream=sys.stdout, level=logging.DEBUG,
                    format="%(asctime)s %(message)s")

import salt.client

client = salt.client.LocalClient()
logger = logging.getLogger(__name__)


def wait_minion_up(minion_id, max_wait):
    output = {}
    start = datetime.datetime.now()
    while minion_id not in output:
        output = client.cmd_full_return(minion_id, 'test.ping', timeout=2)
        delta = datetime.datetime.now() - start
        if not output:
            logger.info("Minion %s is still not up after %d seconds", minion_id,
                        delta.seconds)
            if delta.seconds > max_wait:
                print "Timeout of %d seconds reached to connect minion %s" % (
                    max_wait, minion_id
                )
                sys.exit(1)
        else:
            logger.info("Minion %s is finally up after %d seconds", minion_id,
                        delta.seconds)

if __name__ == '__main__':
    wait_minion_up(sys.argv[1], 300)
