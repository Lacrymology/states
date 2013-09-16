
__author__ = 'Bruno Clermont'
__maintainer__ = 'Bruno Clermont'
__email__ = 'patate@fastmail.cn'
#!/usr/bin/env python
# -*- coding: utf-8 -*-

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
