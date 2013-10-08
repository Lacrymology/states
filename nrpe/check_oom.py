#!/usr/local/nagios/bin/python2
# -*- coding: utf-8 -*-

'''
Copyright (c) 2013, Hung Nguyen Viet
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
'''

__author__ = 'Hung Nguyen Viet <hvnsweeting@gmail.com>'
__maintainer__ = 'Hung Nguyen Viet <hvnsweeting@gmail.com>'
__email__ = 'hvnsweeting@gmail.com'

'''
nrpe check for Out Of Memory (OOM) message in syslog files.
Date: Sep 26 2013
'''

import glob
import argparse
import datetime
import nagiosplugin as nap


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
            delta = (now - lt).seconds
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
