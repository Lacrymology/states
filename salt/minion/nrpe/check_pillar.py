#!/usr/local/nagios/bin/python2
# {{ salt['pillar.get']('message_do_not_modify') }}
# -*- coding: utf-8 -*-
# Use of this is governed by a license that can be found in doc/license.rst.

'''
NRPE check if pillar for current host can be rendered successfully.
'''

import logging
import os

import nagiosplugin as nap

log = logging.getLogger('nagiosplugin.salt.minion.pillar_render')

from pysc import nrpe


class PillarRender(nap.Resource):
    def __init__(self, salt_timeout):
        self.salt_timeout = salt_timeout

    def probe(self):
        import salt.syspaths as syspaths
        import salt.config
        import salt.minion

        config_file = os.path.join(syspaths.CONFIG_DIR, 'minion')
        opts = salt.config.minion_config(config_file)
        opts['auth_timeout'] = self.salt_timeout
        minion = salt.minion.SMinion(opts)
        output = minion.functions['pillar.items']()

        if "_errors" in output:
            error = output['_errors']
            log.error('Error: %s', error)
            render_errors = 1
        else:
            render_errors = 0
        return [nap.Metric('pillar_render_errors', render_errors,
                           context='errors')]


def check_good_pillar(config):
    return (
        PillarRender(config['salt_timeout']),
        nap.ScalarContext('errors', warning='0:0', critical='0:0'),
    )


if __name__ == "__main__":
    nrpe.check(check_good_pillar, {})
