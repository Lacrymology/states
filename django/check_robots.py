#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Copyright (c) 2013, Bruno Clermont
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

"""
Check if robots.txt exists and contains values.

Usage::

  check_robots.py [hostname|or IP]
"""

__author__ = 'Bruno Clermont'
__maintainer__ = 'Bruno Clermont'
__email__ = 'patate@fastmail.cn'

import robotparser
import sys
import pysc

# TODO: switch to pyfs.nrpe

@pysc.profile(log=__name__)
def main():
    rp = robotparser.RobotFileParser()
    try:
        url = "http://%s/robots.txt" % sys.argv[1]
    except IndexError:
        print "ROBOTS WARNING - missing argument hostname or IP"
        sys.exit(1)

    rp.set_url(url)
    try:
        rp.read()
    except Exception, err:
        print "ROBOTS WARNING - Can't get %s: %s" % (url, err)
        sys.exit(1)

    #if rp.can_fetch("*", "/admin/"):
    #    print 'ROBOTS WARNING - Can fetch /admin/'
    #    sys.exit(1)

    if not rp.can_fetch("*", "/"):
        print "ROBOTS WARNING - Can't fetch /"
        sys.exit(1)

    print 'ROBOTS OK - everything alright'

main()
