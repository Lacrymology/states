#!/usr/local/nagios/bin/python2
# -*- coding: utf-8 -*-

# Copyright (C) 2013 the Institute for Institutional Innovation by Data
# Driven Design Inc.
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE  MASSACHUSETTS INSTITUTE OF
# TECHNOLOGY AND THE INSTITUTE FOR INSTITUTIONAL INNOVATION BY DATA
# DRIVEN DESIGN INC. BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
# ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE
# USE OR OTHER DEALINGS IN THE SOFTWARE.
#
# Except as contained in this notice, the names of the Institute for
# Institutional Innovation by Data Driven Design Inc. shall not be used in
# advertising or otherwise to promote the sale, use or other dealings
# in this Software without prior written authorization from the
# Institute for Institutional Innovation by Data Driven Design Inc.

"""
NRPE check script that checks whether minion ids in salt mine monitoring.data
match exactly salt-key accepted minion ids or not.
"""

__author__ = 'Hung Nguyen Viet <hvnsweeting@gmail.com>'
__maintainer__ = 'Hung Nguyen Viet <hvnsweeting@gmail.com>'
__email__ = 'hvnsweeting@gmail.com'

import logging

import salt.key
import salt.client
import salt.config as config

import nagiosplugin as nap
import pysc
import pysc.nrpe as bfe

log = logging.getLogger('nagiosplugin')


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
        ids_from_mine = self._mine_ids()
        ids_from_salt_key = self._accepted_ids()
        if set(ids_from_salt_key) == set(ids_from_mine):
            return [nap.Metric('mine_minions', 0, min=0, context='minions')]
        else:
            all_ids = set(list(ids_from_salt_key)
                          + list(ids_from_mine))
            diff_ids = set(list(all_ids - ids_from_salt_key) +
                           list(all_ids - ids_from_mine))
            log.debug('Diff minion IDs: %s', diff_ids)
            return [nap.Metric('mine_minions', len(diff_ids),
                               min=0, context='minions')]


@nap.guarded
@pysc.profile(log=log)
def main():
    argp = bfe.ArgumentParser()
    args = argp.parse_args()
    m_ids = MineMinion()
    check = bfe.Check(m_ids, nap.ScalarContext('minions', '0:0', '0:0'))
    check.main(args)

if __name__ == "__main__":
    main()
