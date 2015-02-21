#!/usr/local/nagios/bin/python
# -*- coding: utf-8 -*-
# Use of this is governed by a license that can be found in doc/license.rst.

"""
Nagios plugin to check old or badly uploaded backups to an s3 bucket..
"""

__author__ = 'Tomas Neme'
__maintainer__ = 'Tomas Neme'
__email__ = 'tomas@robotinfra.com'

import logging
import os

import boto

from check_backup_base import BackupFile, check_backup as base_check, defaults
from pysc import nrpe

log = logging.getLogger('nagiosplugin.backup.client.s3')


class S3BackupFile(BackupFile):
    """
    S3-specific backup file checker
    """
    def __init__(self, *args, **kwargs):
        super(S3BackupFile, self).__init__(*args, **kwargs)
        self.key = self.config['s3']['access_key']
        self.secret = self.config['s3']['secret_key']
        self.bucket = self.config['s3']['bucket']

    def files(self):
        log.info("started iterating files")
        s3 = boto.connect_s3(self.key, self.secret)

        log.debug("searching bucket %s", self.bucket)
        # with bucket validation
        bucket = s3.get_bucket(self.bucket)
        # without bucket validation, which is faster and cheaper, but can
        # cause unexpected errors later
        # validate=False,

        # S3 allows /// as a valid path, but we won't support that case
        # user may wrongly config path with/without ending '/', add one
        # and use delimiter to only list file at top prefix level, not
        # list all file recursively, which is expensive.
        prefix = self.prefix.strip('/') + '/'
        # if user set prefix = /, he means to use empty prefix
        if prefix == '/':
            prefix = ''
        for key in bucket.list(prefix=prefix, delimiter='/'):
            log.debug("Processing key %s", key.name)
            if isinstance(key, boto.s3.prefix.Prefix):
                # prefix is a concept same as "directory"
                log.debug('%s is a Prefix, skipping ...', key.name)
                continue
            backup_file = self.make_file(os.path.basename(key.name), key.size)
            # I expect file to have one and only one element
            if backup_file:
                yield backup_file
        log.info("finished iterating files")


def check_backup(config):
    return base_check(S3BackupFile, config)


if __name__ == '__main__':
    nrpe.check(check_backup, defaults)
