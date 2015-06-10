#!/usr/bin/env python
# -*- coding: utf-8 -*-
# Use of this is governed by a license that can be found in doc/license.rst.

"""
Wrapper around integration.py that allow to, optionally, run only a
specific set of test that match the argument in command line.

Argument can be either a string or a chunk such as "2/4" that mean from all
tests, it will be splitted into 4 groups and the second chunk will added to the
list.
You can mix argument such as: run.py diamond 1/3 nrpe 5/6
in a single line.
"""

__author__ = 'Bruno Clermont'
__maintainer__ = 'Bruno Clermont'
__email__ = 'bruno@robotinfra.com'

import sys
import subprocess
import os
from UserList import UserList


def test_script():
    script_path = os.path.abspath(__file__)
    jenkins_dir = os.path.dirname(script_path)
    salt_test = os.path.abspath(
        os.path.join(jenkins_dir, '..')
    )
    return os.path.join(salt_test, 'integration.py')


# http://stackoverflow.com/questions/2130016/
def chunks(l, n):
    """ Yield n successive chunks from l.
    """
    newn = int(1.0 * len(l) / n + 0.5)
    for i in xrange(0, n-1):
        yield l[i*newn:i*newn+newn]
    yield l[n*newn-newn:]


class Tests(UserList):
    def __init__(self, prefix='States.'):
        self._prefix = prefix
        self.__all_tests = None
        UserList.__init__(self)

    @property
    def all_tests(self):
        if not self.__all_tests:
            self.__all_tests = self._list_tests()
        return self.__all_tests

    def _list_tests(self):
        """
        :return: build list of all available tests
        """
        lines = subprocess.check_output((test_script(), '--list')).split(
            os.linesep)
        lines.reverse()
        # remove empty line
        lines = filter(None, lines)
        output = []
        for line in lines:
            if line.startswith(self._prefix):
                output.append(line.split(':')[0])
            else:
                # first line that don't starts with prefix mean list is done
                output.sort()
        return output

    def add_chunk(self, slice_index, size):
        for test in list(chunks(self.all_tests, size))[slice_index - 1]:
            if test not in self.data:
                self.data.append(test)

    def add_filtered(self, keywords):
        """
        :param keywords: list of string to look in test name
        """
        for test in self.all_tests:
            for arg in keywords:
                if arg in test and test not in self.data:
                    self.data.append(test)


def main(suffix='> /root/salt/stdout.log 2> /root/salt/stderr.log'):
    integration_py = test_script()
    if len(sys.argv) > 1:
        tests = Tests()
        args = sys.argv[1:]
        for arg in args:
            if '/' in arg:
                str_index, str_size = arg.split('/')
                args.remove(arg)
                tests.add_chunk(int(str_index), int(str_size))
        tests.add_filtered(args)
        command = ' '.join((
            integration_py,
            ' '.join(tests),
            suffix
        ))
    else:
        command = ' '.join((integration_py, suffix))
    print command
    os.system(command)

if __name__ == '__main__':
    main()
