#!/usr/local/nagios/bin/python2
# -*- coding: utf-8 -*-
# {{ salt['pillar.get']('message_do_not_modify') }}
# Use of this is governed by a license that can be found in doc/license.rst.

"""
NRPE check script that checks whether minion ids in salt mine monitoring.data
match exactly salt-key accepted minion ids or not.
"""

__author__ = 'Viet Hung Nguyen <hvn@robotinfra.com>'
__maintainer__ = 'Viet Hung Nguyen <hvn@robotinfra.com>'
__email__ = 'hvn@robotinfra.com'

import logging

import salt.key
import salt.client
import salt.config as config

import nagiosplugin as nap
from pysc import nrpe

log = logging.getLogger('nagiosplugin.salt.master.mine')


class MineMinion(nap.Resource):
    def _accepted_ids(self):
        key = salt.key.Key(config.master_config('/etc/salt/master'))
        minion_ids = key.list_keys()['minions']
        ret = set(minion_ids)
        log.debug('Minion IDs in Salt key accepted: %s', ret)
        return ret

    def _mine_ids(self):
        client = salt.client.Caller('/etc/salt/minion')
        ids = client.function('mine.get', '*', 'monitoring.data')
        ret = set(id for id in ids if ids[id])
        log.debug('Minion IDs in Salt Mine monitoring.data: %s', ret)
        return ret

    def probe(self):
        log.info("MineMinion.probe started")
        ids_from_mine = self._mine_ids()
        ids_from_salt_key = self._accepted_ids()
        if set(ids_from_salt_key) == set(ids_from_mine):
            log.info("MineMinion.probe ended")
            log.debug("returning 0")
            return [nap.Metric('mine_minions', 0, min=0, context='minions')]
        else:
            all_ids = set(list(ids_from_salt_key)
                          + list(ids_from_mine))
            diff_ids = set(list(all_ids - ids_from_salt_key) +
                           list(all_ids - ids_from_mine))
            log.debug('Diff minion IDs: %s', diff_ids)
            log.info("MineMinion.probe ended")
            log.debug("returning %d", len(diff_ids))
            return [nap.Metric('mine_minions', len(diff_ids),
                               min=0, context='minions')]


def check_mine_minions(_):
    return (MineMinion(), nap.ScalarContext('minions', '0:0', '0:0'))


if __name__ == "__main__":
    nrpe.check(check_mine_minions)
