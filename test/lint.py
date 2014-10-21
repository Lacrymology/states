#!/usr/bin/env python
# -*- encoding: utf-8

"""
A lint script for SaltStack SLS
"""

# Copyright (c) 2014, Hung Nguyen Viet All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice,
# this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright notice,
# this list of conditions and the following disclaimer in the documentation
# and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
# BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
# OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
# IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

__author__ = 'Hung Nguyen Viet'
__maintainer__ = 'Hung Nguyen Viet'
__email__ = 'hvnsweeting@gmail.com'

import re
import sys
import os


def _grep(paths, pattern, *exts):
    '''
    A function that acts like ``grep`` command line tool, but simpler

    paths
        filenames to grep on

    pattern
        regex pattern

    exts
        list of file extensions that grep will only work on
    '''
    all_found = {}
    repat = re.compile(pattern)

    def _grep_file(filename):
        found = {}
        with open(filename, 'rt') as f:
            for lineno, line in enumerate(f):
                if repat.findall(line):
                    found.update({str(lineno + 1): line.strip('\n')})
        return found

    if exts:
        paths = filter(lambda p: any(p.endswith(e) for e in exts), paths)

    for path in paths:
        found = _grep_file(path)
        if found:
            all_found[path] = found

    return all_found


def _print_grep_result(all_found):
    for fn in all_found:
        print 'In file: {0}'.format(fn)
        for line, content in all_found[fn].iteritems():
            print ' line {0}: {1}'.format(line, content)


def _print_tips(content):
    print
    print 'TIPS: {0}'.format(content)
    print '-' * 10


def lint_check_tab_char(paths):
    '''
    Checks whether files in ``paths`` contain tab character or not.
    '''
    found = _grep(paths, '\t')
    if found:
        _print_tips('Must use spaces instead of tab char')
        _print_grep_result(found)
        return False
    return True


def lint_check_numbers_of_order_last(paths, *exts):
    '''
    Checks whether files in ``paths`` contain multiple lines of '- order: last'
    or not. A SLS file should only contain one.
    '''
    if not exts:
        exts = ['jinja2', 'sls']
    found = _grep(paths, '- order: last', *exts)
    many_last = {k: v for k, v in found.iteritems() if len(v) > 1}

    if many_last:
        _print_tips("Only one '- order: last' takes effect, use only one"
                    " of that and replace other with explicit requirement"
                    " (you may want to require ``sls: sls_file`` instead)")
        _print_grep_result(many_last)
        return False
    return True


def lint_check_bad_state_style(paths, *exts):
    '''
    Checks whether files in ``paths`` use alternate style to write a state.
    It should be consistent and uses the original form.
    '''
    if not exts:
        exts = ['sls']
    all_found = _grep(paths, '^  \w*\.\w*:$', *exts)
    filtered_found = {}
    for fn, data in all_found.iteritems():
        # A state ID under ``extend`` and contains ``.`` can be miss understood
        # by our regex. If it's a .py file, then it will be skipped.
        # TODO find a better solution for this than just skip .py files
        # e.g. if file name is .cfg or whatever contains '.'  in its name
        # currently, this works because we only extend *.py states.
        data_without_pystates = {lino: sid for lino, sid in
                                 data.iteritems() if not sid.endswith('.py:')}
        if data_without_pystates:
            filtered_found.update({fn: data_without_pystates})

    if filtered_found:
        _print_tips("Use \nstate:\n  - function\nstyle instead")
        _print_grep_result(filtered_found)
        return False
    return True


def _is_binary_file(fn):
    '''
    Check if ``fn`` is binary file.
    '''

    def _is_binary_string(bytes_):
        '''
        A hack to determine whether input string is binary or not base on
        file utility behavior.

        http://stackoverflow.com/a/7392391/807703
        '''
        textchars = (bytearray([7, 8, 9, 10, 12, 13, 27]) +
                     bytearray(range(0x20, 0x100)))
        return bool(bytes_.translate(None, textchars))

    with open(fn, 'rb') as f:
        return _is_binary_string(f.read(1024))


def process_args():
    argdirs = []
    paths = []

    if len(sys.argv) == 1:
        args = [os.curdir]
        print 'No argument passed, check all files under current directory.'
    else:
        args = sys.argv[1:]

    for i in args:
        if os.path.isdir(i):
            argdirs.append(i)
        elif os.path.isfile(i) and not _is_binary_file(i):
            paths.append(i)
        else:
            print 'Bad argument: {0} is not a directory or text file'.format(i)
            sys.exit(1)

    for argdir in argdirs:
        _paths = []
        for root, dirs, fns in os.walk(argdir):
            # skip dot files / dirs
            fns = [f for f in fns if not f[0] == '.']
            dirs[:] = [d for d in dirs if not d[0] == '.']
            for fn in fns:
                path = os.path.join(root, fn)
                if not _is_binary_file(path):
                    _paths.append(path)
        paths.extend(_paths)

    return paths


def main():
    paths = process_args()
    res = []
    res.append(lint_check_tab_char(paths))
    res.append(lint_check_numbers_of_order_last(paths))
    res.append(lint_check_bad_state_style(paths))
    no_of_false = res.count(False)

    print '\nTotal checks: {0}, total failures: {1}'.format(len(res),
                                                            no_of_false)
    sys.exit(no_of_false)


# TODO: lint check for pip.installed usage - it needs to check 2 continue lines
if __name__ == "__main__":
    main()
