#!/usr/bin/env python2
# -*- coding: utf-8 -*-
# Copyright (c) 2014, Diep Pham
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
# FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
# COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
# INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
# BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
# ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

"""
Script to unban from denyhosts
"""

__author__ = 'Diep Pham'
__maintainer__ = 'Diep Pham'
__email__ = 'favadi@robotinfra.com'

import fileinput
import sys
import subprocess


def delete_matching_line(pattern, files):
    """
    Backup all file in files with .bak extension, delete all line
    contain given pattern.

    Args:
      pattern (str): a regular expression
      files (list): list of filename to delete matching line

    """
    for line in fileinput.input(files, inplace=1, backup='.bak'):
        if not pattern in line:
            print line,
        else:
            sys.stderr.write(
                'line: {} remove {} from file {}\n'.format(
                    fileinput.lineno(), pattern, fileinput.filename()))


def main():
    # list of denyhosts files
    denyhosts_files = [
        '/etc/hosts.deny',
        '/var/lib/denyhosts/hosts',
        '/var/lib/denyhosts/hosts-restricted',
        '/var/lib/denyhosts/hosts-root',
        '/var/lib/denyhosts/hosts-valid',
        '/var/lib/denyhosts/users-hosts',
    ]

    # usage message
    usage = 'usage: denyhosts-unblock <ip_address> ...'

    # get list of arguments, each arg is one ip address to unban
    args = sys.argv[1:]

    # need one or more arg
    if args:
        # stop denyhosts
        print 'stop denyhosts'
        subprocess.check_call(['/etc/init.d/denyhosts', 'stop'])

        # delete matching ip
        for arg in args:
            delete_matching_line(arg, denyhosts_files)

        # start denyhosts
        print 'start denyhosts'
        subprocess.check_call(['/etc/init.d/denyhosts', 'start'])
    else:
        print usage


if __name__ == '__main__':
    main()
