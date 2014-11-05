#!/usr/local/nagios/bin/python

# Copyright (c) 2013, David Hannequin
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice, this
#    list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
# ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

"""
Nagios plugin to check the memory usage.
"""

__author__ = 'David Hannequin <david.hannequin@gmail.com>, ' \
    'Hartmut Goebel <h.goebel@crazy-compilers.com>'
__maintainer__ = 'Bruno Clermont'
__email__ = 'bruno@robotinfra.com'

import nagiosplugin

from pysc import nrpe

def MemValues():
    """
    Read total mem, free mem and cached from /proc/meminfo

    This is linux-only.
    """
    for line in open('/proc/meminfo').readlines():
        if line.startswith('MemTotal:'):
            memTotal = line.split()[1]
        if line.startswith('MemFree:'):
            memFree = line.split()[1]
        if line.startswith('Cached:'):
            memCached = line.split()[1]
    # :fixme: fails if one of these lines is missing in /proc/meminfo
    return memTotal, memCached, memFree


def percentFreeMem():
    memTotal, memCached, memFree = MemValues()
    return (((int(memFree) + int(memCached)) * 100) / int(memTotal))


class UsedMemory(nagiosplugin.Resource):
    def probe(self):
        pmemUsage = 100 - percentFreeMem()
        yield nagiosplugin.Metric('usedmemory', pmemUsage)


def memory_check(config):
    return (
        UsedMemory(),
        nagiosplugin.ScalarContext(
            'usedmemory', warning=':{}'.format(config['warning']),
            critical=":{}".format(config['critical']),
            fmt_metric="Memory usage: {value:2.1f}%"),
    )



if __name__ == '__main__':
    nrpe.check(
        memory_check,
        {
            'warning': '80',
            'critical': '90',
        }
    )
