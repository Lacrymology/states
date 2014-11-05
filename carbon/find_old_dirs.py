#!/usr/bin/env python
# -*- encoding: utf-8

"""
A script for finding (and/or deleting) all old files/directories under
given path(s).
A directory is considered old if ALL files it contains have not changed since
last N days - N passed by user.
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

import argparse
import os
import logging
import shutil
from datetime import datetime, timedelta

logging.basicConfig(level=logging.WARNING)
log = logging.getLogger()


def _contains_all_old_files(dirpath, days):
    log.debug('Checking directory %s', dirpath)
    for root, dirs, files in os.walk(dirpath):
        for f in files:
            path = os.path.join(root, f)
            if os.path.isfile(path) or os.path.isdir(path):
                if _is_new(path, days):
                    log.debug(('File %s is modified since last %d days, '
                              'skip containing dir'), path, days)
                    return False
    return True


def _is_new(fpath, days):
    '''
    file is last modified since ``days`` days ago
    '''
    return (datetime.now() - datetime.fromtimestamp(os.stat(fpath).st_mtime) <
            timedelta(days))


def _delete_or_print(fpath, delete=False):
    if delete:
        shutil.rmtree(fpath, ignore_errors=True)
    else:
        print fpath


def main():
    argp = argparse.ArgumentParser()
    argp.add_argument('--days', help=('number of days that file should '
                      'be considered old'), default=10, metavar='DAYS',
                      type=int)
    argp.add_argument('--delete', help='delete found directory',
                      action='store_true')
    argp.add_argument('rootdirs', nargs='+',
                      help=('root dir(s) of a cache storage, base on '
                            'suffix of carbon-cache process'))
    args = argp.parse_args()

    for rootdir in args.rootdirs:
        log.info('Checking old directories under %s', args.rootdir)
        for adir in os.listdir(rootdir):
            fpath = os.path.join(os.path.abspath(rootdir), adir)
            if os.path.isdir(fpath):
                if _contains_all_old_files(fpath, args.days):
                    _delete_or_print(fpath, args.delete)
            else:
                if not _is_new(fpath, args.days):
                    _delete_or_print(fpath, args.delete)


if __name__ == "__main__":
    main()
