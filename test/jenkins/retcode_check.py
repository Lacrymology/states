#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Copyright (c) 2013, Hung Nguyen Viet
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
Take output of salt cmd.run_all --out json
and sys.exit it's value

This is only used to make a jenkins job fail if something bad happened
during execution.
"""

__author__ = 'Hung Nguyen Viet'
__maintainer__ = 'Bruno Clermont, Hung Nguyen viet'
__email__ = 'patate@fastmail.cn, hvnsweeting@gmail.com'

import json
import sys
import os
import re

json_text = sys.stdin.read()
try:
    data = json.loads(json_text)
except ValueError:
    sys.stderr.write(json_text)
    sys.exit(1)
keys = data.keys()
if len(keys) != 1:
    print 'More than 1 key: %d: %s' % (len(data), keys)

result = data[keys[0]]

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

pattern = re.compile('Failed: .*(\d+)')
if int(result['retcode']) == 0:
    try:
        if pattern.findall(result['stdout'])[0] == '0':
            sys.exit(0)
    except Exception as e:
        print e

sys.exit(1)
