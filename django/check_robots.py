#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
Check if robots.txt exists and contains values.

Usage::

  check_robots.py [hostname|or IP]
"""

import robotparser
import sys

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
