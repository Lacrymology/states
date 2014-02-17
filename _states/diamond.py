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

import os

def __virtual__():
    '''
    name this state module
    '''
    return 'diamond'

def test(name, map, logfile):
    """
    Run a list of diamond collectors and make sure the right metrics are
    recorded.

    Expects diamond to have the ArchiveHandler active.

    :param map: a map in the form
        { collectorName: { metric: boolean, metric: .. }, collectorName: ..}
        where collectorName must be just the name of the diamond collectors to
        be run, and each metric maps to a boolean that defines whether 0 is an
        acceptable value for the metric
    :param logfile: the path to the diamond ArchiveHandler logfile. Beware that
        this file will be purged at every run.
    :return:
    """
    ret = {
        'name': 'Test Diamond',
        'changes': {},
        'result': True,
        'comment': '',
    }
    for collector, metrics in map.items():
        ret['changes'][collector] = f = {}
        if os.path.exists(logfile):
            os.unlink(logfile)
        command = 'diamond -r {}Collector'.format(collector)
        res = os.system(command)
        with open(logfile, 'r') as file:
        collected_metrics = {}
            for line in file:
                metric, value, timestamp = line.split()
                collected_metrics[metric] = value

        for metric in metrics:
            if metric not in collected_metrics:
                f[metric] = {
                    'old': "Expected",
                    'new': 'Not collected',
                }
            else:
                try:
                    value = float(collected_metrics[metric])
                except ValueError, e:
                    value = None

                if (not metrics[metric]) and (not value):
                    f[metric] = {
                        'old': 'Expected non-zero numerical value',
                        'new': collected_metrics[metric],
                    }

        # finally, update 'result': if there's anything in f, we've failed
        ret['result'] = ret['result'] and not bool(f)

    return ret
