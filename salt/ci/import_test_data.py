#!/usr/bin/env python
# -*- coding: utf-8 -*-
__author__ = 'Hung Nguyen Viet'
__maintainer__ = 'Bruno Clermont, Hung Nguyen viet'
__email__ = 'patate@fastmail.cn, hvnsweeting@gmail.com'

"""
This script import test data output uploaded by cp.push
to jenkins workspace
"""

import os
import sys
import pwd


def move_file(basename, source_dir, workspace,
              user):
    source_filename = os.path.join(source_dir, basename)
    if not os.path.exists(source_filename):
        raise OSError("Can't find %s file %s" % (basename,
                                                 source_filename))
    destination_filename = os.path.join(workspace, basename)
    os.rename(source_filename, destination_filename)
    os.chown(destination_filename, user.pw_uid, user.pw_gid)


def move_logs(basename, minion_id, workspace,
              username='jenkins', remote_dir='/root/salt',
              minions_dir='/var/cache/salt/master/minions'):
    try:
        user = pwd.getpwnam(username)
    except KeyError:
        raise OSError('missing user %s' % username)

    if not os.path.exists(minions_dir):
        raise OSError("Can't find salt master cache minions directory %s"
                      % minions_dir)
    if not os.path.exists(workspace):
        raise OSError("Can't find workspace directory %s" % workspace)

    minion_dir = os.path.join(minions_dir, minion_id)
    if not os.path.exists(minion_dir):
        raise OSError("minion %s didn't pushed a file yet, can't find %s" % (
            minion_id, minion_dir))

    source_dir = os.path.join(minion_dir, 'files') + remote_dir
    if not os.path.exists(source_dir):
        raise OSError("minion %s didn't pushed log files yet, can't find %s" % (
            minion_id, source_dir))

    move_file(basename, source_dir, workspace, user)


def main():
    if len(sys.argv) != 4:
        print 'Invalid arguments, syntax: %s [file] [minion-id] [workspace]'\
              % sys.argv[0]
        sys.exit(1)

    try:
        move_logs(*sys.argv[1:4])
    except Exception, err:
        print str(err)
        sys.exit(1)

if __name__ == '__main__':
    main()


__author__ = 'Hung Nguyen Viet'
__maintainer__ = 'Bruno Clermont, Hung Nguyen Viet'
__email__ = 'patate@fastmail.cn, hvnsweeting@gmail.com'
