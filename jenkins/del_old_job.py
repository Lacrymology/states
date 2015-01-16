#!/usr/bin/env python2
# -*- coding: utf-8 -*-

'''
Script for deleting old disabled jobs.
A job is considered old if all log files are older than N days.
'''

# Use of this source code is governed by a BSD license that can be
# found in the doc/license.rst file.

__author__ = 'Viet Hung Nguyen <hvn@robotinfra.com>'
__maintainer__ = 'Viet Hung Nguyen <hvn@robotinfra.com>'
__email__ = 'hvn@robotinfra.com'

import argparse
import glob
import os
import logging
import logging.handlers
import shutil
import time
import xml.etree.ElementTree as ET

import requests


log = logging.getLogger('del_old_job')
syslog = logging.handlers.SysLogHandler()
syslog.setFormatter(logging.Formatter("%(name)s %(message)s"))
log.addHandler(syslog)
log.setLevel(logging.INFO)


def _is_old_job(path, days):
    '''
    '''
    files_olds = {}
    for fn in glob.glob(os.sep.join([path, 'builds', 'last*'])):
        buildpath = os.path.join(path, fn)
        try:
            buildlog = os.path.join(buildpath, 'log')
            mage = time.time() - os.stat(buildlog).st_mtime
        except OSError:
            pass
        else:
            files_olds[buildlog] = False
            if mage > days * 86400:
                files_olds[buildlog] = True
            log.debug('%s is %d days, is%s old.', buildlog, mage/86400,
                      ' ' if files_olds[buildlog] else ' not')

    is_old = all(files_olds.values())
    log.debug(files_olds)
    log.debug('%s is old? %s', path, is_old)
    return is_old


def _is_disabled(jobpath):
    config = os.path.join(jobpath, 'config.xml')
    try:
        tree = ET.parse(config)
        return tree.getroot().find('disabled').text == 'true'
    except IOError as e:
        log.debug('Job config does not exist: %s', e)
        return True
    except Exception:
        log.debug('Malformed XML config %s', e)
        return False


def _delete_job(jobname):
    domain = "{{ salt['pillar.get']('jenkins:hostnames')[0] }}"
    scheme = {% if salt['pillar.get']('jenkins:ssl') %}'https'{%- else %}'http'{%- endif %}

    cleaner_user = "{{ salt['pillar.get']('jenkins:job_cleaner:username') }}"
    cleaner_token = "{{ salt['pillar.get']('jenkins:job_cleaner:token') }}"
    url = '{0}://{1}:{2}@{3}/job/{4}/doDelete'.format(
            scheme,
            cleaner_user,
            cleaner_token,
            domain,
            jobname
    )
    out = requests.post(url)
    log.info('%s: %s', url, out.status_code)


def delete_old_jobs(jobdir, days):
    for jobname in os.listdir(jobdir):
        fullpath = os.path.join(jobdir, jobname)
        if os.path.isdir(fullpath):
            log.debug('Examining %s', fullpath)
            if _is_disabled(fullpath) and _is_old_job(fullpath, days):
                _delete_job(jobname)


def main():
    argp = argparse.ArgumentParser(__doc__)
    default_days = "{{ salt['pillar.get']('jenkins:job_cleaner:days_to_del', 15) }}"
    argp.add_argument('--days', metavar='N', default=default_days, type=int,
                      help='delete job if its age is greater than N')
    args = argp.parse_args()

    delete_old_jobs('/var/lib/jenkins/jobs', args.days)


if __name__ == "__main__":
    main()
