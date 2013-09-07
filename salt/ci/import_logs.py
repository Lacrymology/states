#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
This script import test data output uploaded by cp.push
to jenkins workspace
"""

import os
import sys
import pwd


def move_logs(job_id, job_name, minion_id, workspace, username='jenkins',
              log_dir='/root/salt',
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

    log_directory = os.path.join(minion_dir, 'files') + log_dir
    if not os.path.exists(log_directory):
        raise OSError("minion %s didn't pushed log files yet, can't find %s" % (
            minion_id, log_directory))

    for log_type in ('stdout', 'stderr'):
        source_basename = '{0}-{1}-{2}.log.xz'.format(job_name, job_id,
                                                      log_type)
        source_filename = os.path.join(log_directory, source_basename)
        if not os.path.exists(source_filename):
            raise OSError("Can't find log type %s file %s" % (log_type,
                                                              source_filename))
        destination_basename = '{0}-{1}.log.xz'.format(job_id, log_type)
        destination_filename = os.path.join(workspace, destination_basename)
        os.rename(source_filename, destination_filename)
        os.chown(destination_filename, user.pw_uid, user.pw_gid)


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
