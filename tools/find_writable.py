#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Usage of this is governed by a license that can be found in doc/license.rst.

"""
List all files writable by non-root user
"""

__author__ = 'Quan Tong Anh'
__maintainer__ = 'Quan Tong Anh'
__email__ = 'quanta@robotinfra.com'

import os
import sys
import stat
import pwd
import grp


uids = [u.pw_uid for u in pwd.getpwall()]
gids = [g.gr_gid for g in grp.getgrall()]


def print_non_root_writable(pathname):
    statinfo = os.stat(pathname)
    mode = statinfo.st_mode
    if stat.S_ISREG(mode):
        uid = statinfo.st_uid
        gid = statinfo.st_gid
        if uid != 0 or (gid != 0 and (mode & stat.S_IWGRP)):
            owner = pwd.getpwuid(uid).pw_name if uid in uids else uid
            group = grp.getgrgid(gid).gr_name if gid in gids else gid
            print("{0} mode={1} user={2} group={3}".format(
                pathname,
                oct(mode)[4:],
                owner,
                group))


def walktree(top):
    for root, _, files in os.walk(top):
        for name in files:
            pathname = os.path.join(root, name)
            # check if pathname is a symlink
            if os.path.islink(pathname):
                target_path = os.readlink(pathname)
                # if target_path is a relative path
                if not os.path.isabs(target_path):
                    # get the full path
                    target_path = os.path.join(
                            os.path.dirname(pathname),
                            target_path)
                # skip broken symlink
                if os.path.exists(target_path):
                    print_non_root_writable(target_path)
            else:
                print_non_root_writable(pathname)


if __name__ == '__main__':
    walktree(sys.argv[1])
