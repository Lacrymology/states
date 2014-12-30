#!/usr/local/nagios/bin/python

# Use of this source code is governed by a BSD license that can be
# found in the doc/license.rst file.

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
