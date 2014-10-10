#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
Exactly like test/jenkins/run.py but it automatically send logs to
/media/sf_tests_results/$MINION_ID/$NOW instead.
"""

import datetime
import os
import sys

import yaml


def insert_test_jenkins_path():
    script_path = os.path.abspath(__file__)
    virtualbox_dir = os.path.dirname(script_path)
    salt_test_jenkins = os.path.abspath(
        os.path.join(virtualbox_dir, '..', 'jenkins')
    )
    # add to the sys.path
    sys.path.insert(0, salt_test_jenkins)


def main():
    insert_test_jenkins_path()
    import run

    # if virtualbox test results directory exists, use it instead of /root/salt
    virtualbox_dir = '/media/sf_test_results'
    salt_config = yaml.load(open('/etc/salt/minion'))
    minion_dir = os.path.join(virtualbox_dir, salt_config['id'])
    if not os.path.isdir(minion_dir):
        os.mkdir(minion_dir)
    log_dir = os.path.join(minion_dir, datetime.datetime.now().isoformat())
    if os.path.isdir(log_dir):
        raise ValueError("How %s can exist now?" % log_dir)
    os.mkdir(log_dir)
    print 'Logs of this build will be in: %s' % log_dir
    run.main(suffix='> {0}/stdout.log 2> {0}/stderr.log'.format(log_dir))

if __name__ == '__main__':
    main()
