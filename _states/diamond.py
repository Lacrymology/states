# -*- coding: utf-8 -*-

# Copyright (c) 2014, Tomas Neme
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


__author__ = 'Tomas Neme'
__maintainer__ = 'Tomas Neme'
__email__ = 'tomas@robotinfra.com'

import glob
import os
import logging
import re

log = logging.getLogger(__name__)


def _remove_log(logfile):
    for fl in glob.glob(logfile + '*'):
        __salt__['file.remove'](fl)

def test(name, map):
    """
    Run a list of diamond collectors and make sure the right metrics are
    recorded.

    Expects diamond to have the ArchiveHandler active, which is the case
    if ``__test__`` pillar key is turned on when state ``diamond`` is applied

    :param dict map: a map in the form::

          { collectorName: { metric: boolean, metric: .. }, collectorName: ..}

        where collectorName must be just the name of the diamond collectors to
        be run, and each metric maps to a boolean that defines whether 0 is an
        acceptable value for the metric. Metrics must not prefix with the
        <hostname>.os, as this module will do that instead.
    """
    logfile = os.path.join(__opts__['cachedir'], 'diamond.archive.log')

    ret = {
        'name': 'Test Diamond',
        'changes': {},
        'result': True,
        'comment': '',
    }

    for collector, metrics in map.items():
        ret['changes'][collector] = change = {}
        _remove_log(logfile)

        if (not collector.startswith('/') and
           not collector.endswith("Collector")):
            collector += 'Collector'

        command = ('/usr/local/diamond/bin/python '
                   '/usr/local/diamond/bin/diamond -l -r {}').format(collector)

        cret = __salt__['cmd.run_all'](command)
        retcode = cret['retcode']

        if retcode != 0:
            _remove_log(logfile)
            ret['comment'] = '%s failed with retcode %d' % (command, retcode)
            ret['result'] = False
            return ret

        if 'Initialized Collector: {}'.format(collector) not in cret['stdout']:
            _remove_log(logfile)
            ret['comment'] = ('{0} was not been initialized, recheck collector'
                              ' name or its config').format(collector)
            ret['result'] = False
            return ret

        collected_metrics = {}
        log.info('Reading from %s', logfile)
        with open(logfile) as file:
            for line in file:
                metric, value, timestamp = line.split()
                collected_metrics[metric] = value
        _remove_log(logfile)
        log.debug('Collected: %s', collected_metrics)

        for metric in metrics:
            fullpath = '.'.join((__grains__['id'], 'os', metric))
            fullpathObj = re.compile(fullpath)
            found = False
            for k in collected_metrics:
                if fullpathObj.match(k):
                    found = True
                    key = k
                    break

            if found:
                log.info('Received metric: %s %s',
                         key, collected_metrics[key])
                try:
                    value = float(collected_metrics[key])
                except ValueError:
                    value = None

                if (not metrics[metric]) and (not value):
                    ret['comment'] = ('{0}: Expected non-zero value '
                                      'for the {1}').format(collector, key)
                else:
                    change[key] = {
                        'old': 'Expected to be recorded',
                        'new': 'Value = {0}'.format(collected_metrics[key])
                    }
            else:
                ret['comment'] = '{0}: {1} is not collected'.format(
                    collector, fullpath)

        if not change:
            ret['result'] = False
            return ret

    return ret
