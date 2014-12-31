#!/usr/local/nagios/bin/python
# -*- encoding: utf-8

"""
NRPE script for checking age of backup files synced by s3lite
"""

# Use of this source code is governed by a BSD license that can be
# found in the doc/license.rst file.

__author__ = 'Hung Nguyen Viet'
__maintainer__ = 'Hung Nguyen Viet'
__email__ = 'hvn@robotinfra.com'

import json
import logging
import os

from datetime import datetime

import boto
import nagiosplugin as nap

from pysc import nrpe

log = logging.getLogger('nagiosplugin.backup.client.s3lite')


class BackupAge(nap.Resource):
    def __init__(self, key, secret, bucket, prefix, path, minion_id,
                 allow_empty=False):
        self.key = key
        self.secret = secret
        self.bucket = bucket
        self.prefix = prefix
        self.path = path
        self.minion_id = minion_id
        self.allow_empty = allow_empty

    def probe(self):
        log.info("BackupAge.probe started")

        def log_and_return(value, *msg, **kwargs):
            log_func = log.__getattribute__(kwargs.get('loglevel', 'error'))
            if msg:
                log_func(*msg)

            return [nap.Metric('age', value, 'hours')]

        log.info("About to get bucket %s from s3", self.bucket)
        log.debug("Connect to s3")
        s3 = boto.connect_s3(self.key, self.secret)
        log.debug("get bucket")
        bucket = s3.get_bucket(self.bucket)
        normalized_fn = self.path.strip(os.sep).replace(os.sep, '_')
        backup_identifier = 's3lite_{0}_{1}.json'.format(self.minion_id,
                                                         normalized_fn)

        log_path = os.path.join(self.prefix.strip('/'), backup_identifier)
        log.debug("getting log key: %s", log_path)
        logkey = bucket.get_key(log_path)
        log.info("Got log file")
        if logkey:
            log.debug(logkey)
            backup_mdata = json.loads(logkey.get_contents_as_string())
            try:
                log.debug(backup_mdata)
                if backup_mdata['processed'] == 0 and not self.allow_empty:
                    log.warning('Last backup processed no-file,'
                                ' maybe backed up dir does not contain'
                                ' any regular file')

                # S3 time format sample 'Wed, 06 Aug 2014 03:07:27 GMT'
                last = datetime.strptime(logkey.last_modified,
                                         '%a, %d %b %Y %H:%M:%S %Z')
                now = datetime.utcnow()
                age_in_hours = (now - last).total_seconds() / 60 / 60
                log.info("BackupAge.probe finished")
                return log_and_return(
                    age_in_hours,
                    'Last backup processed %d files',
                    backup_mdata['processed'],
                    loglevel='info',
                )
            except KeyError:
                log.critical('Log file %s is malformed', log_path)
                raise KeyError('Malformed s3lite log file %s' % log_path)
        else:
            log.critical('Log file %s does not exist', log_path)
            raise RuntimeError('S3lite log %s file does not exist' % log_path)


def s3lite_backup_client_check(config):
    """
    Required configurations:

    - ('path', help='Path used when backup')
    - ('bucket', help='s3://bucket/prefix to check uploaded file')
    """
    try:
        parsed = boto.urlparse.urlparse(config['bucket'])
        bucket_name, prefix = parsed.netloc, parsed.path
        prefix = prefix[1:]  # prefix must not start with /

        return (
            BackupAge(
                config['s3']['access_key'],
                config['s3']['secret_key'],
                bucket_name,
                prefix,
                config['path'],
                config['minion_id'],
                allow_empty=config['empty'],
            ),
            nap.ScalarContext('age', config['warning'], config['warning'])
        )

    except boto.exception.S3ResponseError:
        raise ValueError('Bad or non-existing bucket name')


if __name__ == "__main__":
    nrpe.check(s3lite_backup_client_check, {
        'empty': False,
        'warning': '48',
        'timeout': None,
        'config': '/etc/nagios/backup.yml',
    })
