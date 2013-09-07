#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
This script import log file upload by cp.push to jenkins workspace
"""

import os
import shutil
import sys
import pwd

# /var/cache/salt/master/minions/integration-common_testing-1/files/root/salt/

def move_logs(job_id, minion_id, workspace, user='jenkins', log_dir='/root/salt',
              minions_dir='/var/cache/salt/master/minions',
              clear_minion_dir=True):
    try:
        user = pwd.getpwnam(user)
    except KeyError:
        raise OSError('missing user %s' % user)

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
        source_basename = '{0}-{1}.log.xz'.format(minion_id, log_type)
        source_filename = os.path.join(log_directory, source_basename)
        if not os.path.exists(source_filename):
            raise OSError("Can't find log type %s file %s" % (log_type,
                                                              source_filename))
        destination_basename = '{0}.log.xz'.format(job_id)
        destination_filename = os.path.join(workspace, destination_basename)
        os.rename(source_filename, destination_filename)
        os.chown(destination_basename, user.pw_uid, user.pw_gid)

    if clear_minion_dir:
        shutil.rmtree(minion_dir)

def main():
    if len(sys.argv) != 3:
        print 'Invalid arguments, syntax: %s [jobid] [minion-id] [workspace]'\
              % sys.argv[0]
        sys.exit(1)

    job_id, minion_id, workspace = sys.argv[1:4]

    try:
        move_logs(job_id, minion_id, workspace, clear_minion_dir=False)
    except Exception, err:
        print str(err)
        sys.exit(1)

if __name__ == '__main__':
    main()
