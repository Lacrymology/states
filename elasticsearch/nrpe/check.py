#!/usr/local/nagios/bin/python
# -*- coding: utf-8 -*-

# Use of this source code is governed by a BSD license that can be
# found in the doc/license.rst file.

"""
Nagios plugin to check an elasticsearch cluster status.
"""

__author__ = 'Bruno Clermont'
__maintainer__ = 'Bruno Clermont'
__email__ = 'bruno@robotinfra.com'

import nagiosplugin
import requests
import logging
from pysc import nrpe

log = logging.getLogger("nagiosplugin.elasticsearch.cluster_nodes")


def elasticsearch_version():
    req = requests.get('http://127.0.0.1:9200/')
    major, minor, bug = req.json()['version']['number'].split('.')
    return int(major), int(minor), int(bug)


class ClusterNodes(nagiosplugin.Resource):
    def probe(self):
        log.info("ClusterNode.probe started")
        major = elasticsearch_version()[0]
        if major < 1:
            rsc = 'nodes/'
        else:
            rsc = 'states/nodes/'
        log.debug("calling localhost to get cluster %s", rsc)
        req = requests.get('http://127.0.0.1:9200/_cluster/' + rsc)
        log.debug("response: %s", req.content)
        log.info("ClusterNode.probe finished")
        return [nagiosplugin.Metric('nodes', len(req.json()['nodes']), min=0)]


def check_procs(config):
    return (
        ClusterNodes(),
        nagiosplugin.ScalarContext('nodes',
                                   config['critical'],
                                   config['critical'],
                                   fmt_metric='{value} nodes in cluster')
    )


if __name__ == '__main__':
    nrpe.check(check_procs)
