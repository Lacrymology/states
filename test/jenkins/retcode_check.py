#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Use of this source code is governed by a BSD license that can be
# found in the doc/license.rst file.

"""
Take output of salt cmd.run_all --out json
and sys.exit it's value

This is only used to make a jenkins job fail if something bad happened
during execution.
"""

__author__ = 'Viet Hung Nguyen'
__maintainer__ = 'Bruno Clermont, Hung Nguyen viet'
__email__ = 'bruno@robotinfra.com, hvn@robotinfra.com'

import json
import sys
import os
import re

json_text = sys.stdin.read()
try:
    data = json.loads(json_text)
except ValueError:
    sys.stderr.write('Malformed JSON: %s' % json_text)
    sys.exit(1)

keys = data.keys()
if len(keys) != 1:
    print 'More than 1 key: %d: %s' % (len(data), keys)

result = data[keys[0]]
print 'Result: {0}'.format(result)

if type(result) == bool:
    if result:
        sys.exit(0)
    else:
        sys.exit(1)


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

if int(result['retcode']) == 0:
    try:
        # it is result of calling state.*
        if 'Failed: ' in result['stdout']:
            pattern = re.compile('Failed: .*(\d+)')
            if pattern.findall(result['stdout'])[0] == '0':
                sys.exit(0)
        else:
            # result of another command, exits with retcode
            sys.exit(0)

    except Exception as e:
        print e

sys.exit(1)
