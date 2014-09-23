#!/usr/local/nagios/bin/python2
# -*- coding: utf-8 -*-

# Copyright (c) 2013, Hung Nguyen Viet
# All rights reserved.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

"""
nrpe check for Out Of Memory (OOM) message in syslog files.
"""

__author__ = 'Hung Nguyen Viet <hvnsweeting@gmail.com>'
__maintainer__ = 'Hung Nguyen Viet <hvnsweeting@gmail.com>'
__email__ = 'hvnsweeting@gmail.com'

import glob
import argparse
import datetime
import nagiosplugin as nap
import pysc


class OOM_Message(nap.Resource):
    def __init__(self, second_ago=3600):
        self.second_ago = second_ago

    def probe(self):
        found = self.number_of_oom_message()
        return [nap.Metric('oom_message', found, min=0, context='msg')]

    def is_near(self, log_msg):
        '''
        log_msg sample:
        Sep 25 07:59:28 integration kernel: [21152.249560] Out of memory:\
                Kill process 1108 (python) score 796 or sacrifice child
        '''
        this_year = str(datetime.datetime.now().year)
        time_in_log = ' '.join(log_msg.split()[:3])
        logtime = '{0} {1}'.format(this_year, time_in_log)
        lt = datetime.datetime.strptime(logtime, '%Y %b %d %H:%M:%S')
        now = datetime.datetime.now()
        if now < lt:
            # this means log_msg is created in last year, and now is new year
            return False
        else:
            delta = (now - lt).total_seconds()
            return delta <= self.second_ago

    def number_of_oom_message(self):
        cntr = 0
        syslog_files = glob.glob('/var/log/syslog*')
        for fn in syslog_files:
            with open(fn) as f:
                for line in f:
                    if 'Out of memory' in line and self.is_near(line):
                        cntr += 1
        return cntr


@nap.guarded
@pysc.profile(log='nrpe.check_oom')
def main():
    argp = argparse.ArgumentParser()
    argp.add_argument('-s', '--seconds', type=int,
                      help='check messages since X seconds ago')
    args = argp.parse_args()
    oom = OOM_Message(args.seconds) if args.seconds else OOM_Message()
    check = nap.Check(oom, nap.ScalarContext('msg', '0:0', '0:0'))
    check.main()

if __name__ == "__main__":
    main()
