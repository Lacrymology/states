#!/usr/local/nagios/bin/python2
# -*- coding: utf-8 -*-

'''
NRPE check if pillar for current host can be rendered successfully.
'''

# Use of this source code is governed by a BSD license that can be
# found in the doc/license.rst file.

__author__ = 'Hung Nguyen Viet'
__maintainer__ = 'Hung Nguyen Viet'
__email__ = 'hvn@robotinfra.com'

import json
import logging
import subprocess

import nagiosplugin as nap

log = logging.getLogger('nagiosplugin.salt.minion.pillar_render')

from pysc import nrpe


class PillarRender(nap.Resource):
    def probe(self):
        get_all_pillar_cmd = 'salt-call pillar.items --out=json'.split()
        out = subprocess.check_output(get_all_pillar_cmd)
        jsonoutput = json.loads(out)
        log.debug(jsonoutput)
        if "_errors" in jsonoutput['local']:
            error = jsonoutput['local']['_errors']
            log.error('Error: %s', error)
            render_errors = 1
        else:
            render_errors = 0
        return [nap.Metric('pillar_render_errors', render_errors,
                           context='errors')]


def check_good_pillar(config):
    return (
        PillarRender(),
        nap.ScalarContext('errors', warning='0:0', critical='0:0'),
    )


if __name__ == "__main__":
    nrpe.check(check_good_pillar, {})
