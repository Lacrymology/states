#!/usr/local/nagios/bin/python
# -*- coding: utf-8 -*-
# Use of this is governed by a license that can be found in doc/license.rst.

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
logging.getLogger("requests").setLevel(logging.WARNING)


class ClusterNodes(nagiosplugin.Resource):
    def probe(self):
        log.debug("ClusterNode.probe started")
        rsc = 'health'
        log.debug("calling localhost to get cluster %s", rsc)
        req = requests.get('http://127.0.0.1:9200/_cluster/' + rsc)
        log.debug("response: %s", req.content)
        log.debug("ClusterNode.probe finished")
        return [nagiosplugin.Metric(
            'nodes', req.json()['number_of_nodes'], min=0)]


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
