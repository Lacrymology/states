#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
Take output of salt cmd.retcode --out json
and sys.exit it's value

This is only used to make a jenkins job fail if something bad happened
during cmd.run
"""

import json
import sys

data = json.load(sys.stdin)
keys = data.keys()
if len(keys) != 1:
    print 'More than 1 key: %d: %s' % (len(data), keys)

sys.exit(data[keys[0]])
