#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
Take output of salt cmd.run_all --out json
and sys.exit it's value

This is only used to make a jenkins job fail if something bad happened
during execution
"""

import json
import sys
import os

data = json.load(sys.stdin)
keys = data.keys()
if len(keys) != 1:
    print 'More than 1 key: %d: %s' % (len(data), keys)

result = data[keys[0]]


def write_output(output_type):
    handler = getattr(sys, output_type)
    handler.write(os.linesep)
    handler.write(output_type.upper())
    handler.write(os.linesep)
    handler.write("-" * 79)
    handler.write(os.linesep)
    handler.write(result[output_type])
    handler.write(os.linesep)

write_output('stdout')
write_output('stderr')
sys.exit(result['retcode'])
