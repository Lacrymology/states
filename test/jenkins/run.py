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

import argparse
import subprocess
import os


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


class Tests(object):
    def __init__(self, prefix='States.'):
        self._prefix = prefix
        self.__all_tests = None
        self.data = set()

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

        output = [line.split(':')[0] for line in lines
                  if line.startswith(self._prefix)]
        return sorted(output)

    def add_chunk(self, slice_index, size):
        self.data.update(list(chunks(self.all_tests, size))[slice_index - 1])

    def add_filtered(self, keyword):
        for test_name in self.all_tests:
            if keyword in test_name:
                self.data.add(test_name)


def main(suffix='> /root/salt/stdout.log 2> /root/salt/stderr.log'):
    integration_py = test_script()
    argp = argparse.ArgumentParser()
    argp.add_argument('words', nargs='*', help='prefix or chunk')
    argp.add_argument('--dry-run', action='store_true',
                      help='show command that will be run')

    args = argp.parse_args()

    if args.words:
        tests = Tests()
        arguments = args.words[:]
        for arg in arguments[:]:
            if '/' in arg:
                str_index, str_size = arg.split('/')
                arguments.remove(arg)
                tests.add_chunk(int(str_index), int(str_size))
            else:
                tests.add_filtered(arg)

        command = ' '.join((
            integration_py,
            ' '.join(tests.data),
            suffix
        ))
    else:
        command = ' '.join((integration_py, suffix))

    print command
    if not args.dry_run:
        os.system(command)

if __name__ == '__main__':
    main()
