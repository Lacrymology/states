#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Use of this source code is governed by a BSD license that can be
# found in the doc/license.rst file.

"""
Check if robots.txt exists and contains values.

Usage::

  check_robots.py [hostname|or IP]
"""

__author__ = 'Bruno Clermont'
__maintainer__ = 'Bruno Clermont'
__email__ = 'bruno@robotinfra.com'

import robotparser
import nagiosplugin

from pysc import nrpe


class BoolishContext(nagiosplugin.Context):
    """
    Returns OK if the value is empty and Critical otherwise

    The result hint is set to the value itself
    """
    def evaluate(self, metric, resource):
        state = nagiosplugin.state.Ok
        if metric.value:
            state = nagiosplugin.state.Critical

        return self.result_cls(state, metric.value, metric)


class RobotsFile(nagiosplugin.Resource):
    def __init__(self, domain=None, *args, **kwargs):
        if domain is None:
            raise ValueError("You must pass a domain kwarg to RobotsFile")
        super(RobotsFile, self).__init__(*args, **kwargs)
        self.domain = domain

    def probe(self):
        rp = robotparser.RobotFileParser()
        url = "http://%s/robots.txt" % self.domain

        rp.set_url(url)
        try:
            rp.read()
        except Exception, err:
            yield nagiosplugin.Metric("robotsfile",
                                      "Can't get %s: %s" % (url, err))

        if not rp.can_fetch("*", "/"):
            yield nagiosplugin.Metric("robotsfile", "Can't fetch /")

        # "None" is a successful result
        yield nagiosplugin.Metric("robotsfile", None)


def check_robots(config):
    """
    Required configs:

    - domain
    """
    return (
        RobotsFile(domain=config['domain']),
        BoolishContext("robotsfile")
    )

if __name__ == '__main__':
    nrpe.check(check_robots)
