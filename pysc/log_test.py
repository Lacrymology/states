#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
Log generator.
"""

import logging

import pysc

logger = logging.getLogger()


class LogTest(pysc.Application):
    """
    Application that send logs in all level to test Python logging configuration
    and delivery mechanism (gelf/graylog2 or rsyslog).
    """

    def main(self):
        """
        Send logs to all levels.
        """
        for level in ('debug', 'info', 'warning', 'error', 'critical'):
            func = getattr(logger, level)
            func("Log message sent to '%s'", level)

if __name__ == "__main__":
    LogTest().run()
