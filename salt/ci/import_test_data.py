#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
This script import test data output uploaded by cp.push
to jenkins workspace
"""

import os
import sys
import pwd


def move_file(source_basename, destination_basename, source_dir, workspace,
              user):
    source_filename = os.path.join(source_dir, source_basename)
    if not os.path.exists(source_filename):
        raise OSError("Can't find %s file %s" % (source_basename,
                                                 source_filename))
    destination_filename = os.path.join(workspace, destination_basename)
    os.rename(source_filename, destination_filename)
    os.chown(destination_filename, user.pw_uid, user.pw_gid)


def move_logs(job_id, job_name, minion_id, workspace, username='jenkins',
              remote_dir='/root/salt',
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

    for log_type in ('stdout', 'stderr'):
        move_file(
            '{0}.log.xz'.format(log_type),
            '{0}-{1}.log.xz'.format(job_id, log_type),
            source_dir, workspace, user
        )
    test_report = 'test-reports.xml'
    move_file(test_report, test_report, source_dir, workspace, user)


def main():
    if len(sys.argv) != 5:
        print 'Invalid arguments, syntax: %s [job-id] [job-name] ' \
              '[minion-id] [workspace]' % sys.argv[0]
        sys.exit(1)

    job_id, job_name, minion_id, workspace = sys.argv[1:5]

    try:
        move_logs(job_id, job_name, minion_id, workspace)
    except Exception, err:
        print str(err)
        sys.exit(1)

if __name__ == '__main__':
    main()
