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
    all_found = {}
    repat = re.compile(pattern)

    def _grep_file(filename):
        found = []
        with open(filename, 'rt') as f:
            for lineno, line in enumerate(f):
                if repat.findall(line):
                    found.append(' '.join((str(lineno + 1), line.strip('\n'))))
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
        print fn
        for line in all_found[fn]:
            print ' ', line


def _print_tips(content):
    print
    print 'TIPS: {0}'.format(content)
    print '-' * 10


def lint_check_tab_char(paths):
    found = _grep(paths, '\t')
    if found:
        _print_tips('Must use spaces instead of tab char')
        _print_grep_result(found)
        return False
    return True


def lint_check_numbers_of_order_last(paths, *exts):
    if not exts:
        exts = ['jinja2', 'sls']
    found = _grep(paths, '- order: last', *exts)
    many_last = {k: v for k, v in found.iteritems() if len(v) >= 2}

    if many_last:
        _print_tips("Only one '- order: last' takes effect, use only one"
                    " of that and replace other with explicit requirement"
                    " (you may want to require ``sls: sls_file`` instead)")
        _print_grep_result(many_last)
        return False
    return True


def lint_check_bad_state_style(paths, *exts):
    if not exts:
        exts = ['sls']
    found = _grep(paths, '^  \w*\.\w*:$', *exts)
    if found:
        _print_tips("Use \nstate:\n  - function\nstyle instead")
        _print_grep_result(found)
        return False
    return True


def process_args():
    filepath = sys.argv[1]
    if os.path.isdir(filepath):
        paths = []
        for root, dirs, fns in os.walk(filepath):
            # skip dot files / dirs
            fns = [f for f in fns if not f[0] == '.']
            dirs[:] = [d for d in dirs if not d[0] == '.']
            for fn in fns:
                paths.append(os.path.join(root, fn))
    else:
        paths = sys.argv[1:]

    return paths


def main():
    paths = process_args()
    res = []
    res.append(lint_check_tab_char(paths))
    res.append(lint_check_numbers_of_order_last(paths))
    res.append(lint_check_bad_state_style(paths))
    falses = [i for i in res if i is False]
    no_of_false = len(falses)

    print '\nTotal checks: {0}, total failures: {1}'.format(len(res),
                                                            no_of_false)
    sys.exit(no_of_false)


# TODO: lint check for pip.installed usage - it needs to check 2 continue lines
if __name__ == "__main__":
    main()
