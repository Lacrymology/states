#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Copyright (c) 2013, Bruno Clermont
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
