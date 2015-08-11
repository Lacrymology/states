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


def walktree(top):
    for root, _, files in os.walk(top):
        for name in files:
            pathname = os.path.join(root, name)
            statinfo = os.stat(pathname)
            mode = statinfo.st_mode
            if stat.S_ISREG(mode):
                uid = statinfo.st_uid
                if uid != 0 and (mode & stat.S_IWUSR):
                    print("{0} mode={1} user={2} group={3}".format(
                        pathname,
                        oct(mode)[4:],
                        pwd.getpwuid(uid).pw_name,
                        grp.getgrgid(statinfo.st_gid).gr_name))


if __name__ == '__main__':
    walktree(sys.argv[1])
