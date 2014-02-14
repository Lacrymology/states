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

def test(map, logfile):
    """
    Run a list of diamond collectors and make sure the right metrics are
    recorded.

    Expects diamond to have the ArchiveHandler active.

    :param map: a map in the form
        { collectorName: { metric: boolean, metric: .. }, collectorName: ..}
        where collectorName must be just the name of the diamond collectors to
        be run, and each metric maps to a boolean that defines whether 0 is an
        acceptable value for the metric
    :param logfile: the path to the diamond ArchiveHandler logfile
    :return:
    """
    fails = {}
    for collector, metrics in map.items():
        fails[collector] = f = {}
        if os.path.exists(logfile):
            os.unlink(logfile)
        with open(logfile, 'r') as file:
            for line in file:
                metric, value, timestamp = line.split()
                if metric not in metrics:
                    continue
                if (not value or not float(value)) and not metrics[metric]:
                    f[metric] = (value)
                    continue
                # if this metric is OK, I can delete it from metrics
                del metrics[metric]

        # if there's any metric left, it was not in
        if metrics:
            f.update(metrics)
