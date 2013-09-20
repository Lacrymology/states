#!/usr/bin/env python
# -*- coding: utf-8 -*-
'''
Copyright (c) 2013, Bruno Clermont
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
__author__ = 'Bruno Clermont'
__maintainer__ = 'Bruno Clermont'
__email__ = 'patate@fastmail.cn'

"""
Wrapper around integration.py that allow to, optionally, run only a
specific set of test that match the argument in command line.
"""

import sys
import subprocess
import os

TEST_SCRIPT = "/root/salt/states/test/integration.py"


def list_tests(prefix='States.'):
    """
    :param prefix: the prefix to search for test signature
    :return: list of all available tests
    """
    lines = subprocess.check_output((TEST_SCRIPT, '--list')).split(os.linesep)
    lines.reverse()
    # remove empty line
    del lines[0]
    output = []
    for line in lines:
        if line.startswith(prefix):
            output.append(line.split(':')[0])
        else:
            # first line that don't starts with prefix mean list is done
            output.sort()
            return output


def list_tests_filtered(keywords):
    """
    :param keywords: list of string to look in test name
    :return: list of test that contains any keywords
    """
    output = []
    for test in list_tests():
        for arg in keywords:
            if arg in test and test not in output:
                output.append(test)
    output.sort()
    return output

if __name__ == '__main__':
    suffix = '> /root/salt/stdout.log 2> /root/salt/stderr.log'
    if len(sys.argv) > 1:
        command = ' '.join((
            TEST_SCRIPT,
            ' '.join(list_tests_filtered(sys.argv[1:])),
            suffix
        ))
    else:
        command = ' '.join((TEST_SCRIPT, suffix))
    os.system(command)
