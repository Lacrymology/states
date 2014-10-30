#!/usr/local/s3lite/bin/python
# -*- encoding: utf-8

"""
Backup script which syncs files to S3 with small memory using.
"""

# Copyright (c) 2014, Hung Nguyen Viet All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice,
# this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright notice,
# this list of conditions and the following disclaimer in the documentation
# and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
# BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
# OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
# IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

__author__ = 'Hung Nguyen Viet'
__maintainer__ = 'Hung Nguyen Viet'
__email__ = 'hvnsweeting@gmail.com'

import collections
import hashlib
import json
import os
import logging
import sys

import boto
from boto.s3.key import Key
from boto.s3.connection import S3Connection

import pysc


logger = logging.getLogger(__name__)


def md5hash(filepath):
    """
    Get the md5 hash of a file
    """
    md5 = hashlib.md5()
    with open(filepath, 'rb') as f:
        for chunk in iter(lambda: f.read(128 * md5.block_size), b''):
            md5.update(chunk)
    return md5.hexdigest()


class S3Util(object):
    """
    Helper class that holds s3 functions
    """
    def __init__(self, key_id, secret_key, minion_id=None):
        self.conn = S3Connection(key_id, secret_key)
        self.buckets = self.conn.get_all_buckets()
        self.minion_id = minion_id

    def _gen_path(self, prefix, filepath):
        filename = os.path.basename(filepath)
        return os.path.join(prefix, filename) if prefix else filename

    def upload_file(self, bucket, filepath, prefix):
        k = Key(bucket)
        k.key = self._gen_path(prefix, filepath)
        logger.info('uploading %s to %s,%s', filepath, bucket.name, k.key)

        wrote_bytes = k.set_contents_from_filename(filepath)
        logger.debug('wrote %d bytes', wrote_bytes)
        return wrote_bytes

    def sync(self, bucket, path, prefix=''):
        logger.debug('Prefix to sync: %s', prefix)
        localfiles = self.get_filedatas
        counter = collections.Counter({'uploaded': 0,
                                       'existed_before_sync': 0})

        def _log_progress(counter):
            logger.info('Processed %d, uploaded %d, existed %d',
                        counter['uploaded'] + counter['existed_before_sync'],
                        counter['uploaded'],
                        counter['existed_before_sync'])

        logger.info('Uploading files')
        for lfn in localfiles(bucket, path, prefix):
            rpath = self._gen_path(lfn['prefix'], lfn['fullpath'])
            logger.debug('To: %s', rpath)
            rfile = bucket.get_key(rpath)
            if rfile:
                # etag is usually md5sum of that file
                rmd5 = rfile.etag.strip('"')
                if rmd5 == unicode(lfn['md5']):
                    logger.debug('%s existed on S3 at %s', lfn['fullpath'],
                                 rfile.name)
                    counter['existed_before_sync'] += 1
                    _log_progress(counter)
                    continue

            self.upload_file(lfn['bucket'], lfn['fullpath'], lfn['prefix'])
            counter['uploaded'] += 1
            _log_progress(counter)

        def log_result(bucket, prefix, path):
            # each backup need an identifier to distinguish with others,
            # use path of it as name of the file, and place that file in
            # the s3path it upload to.
            normalized_fn = path.strip(os.sep).replace(os.sep, '_')
            backup_identifier = 's3lite_{0}_{1}.json'.format(self.minion_id,
                                                             normalized_fn)
            filepath = os.path.join(prefix, backup_identifier)

            logger.info('Writing log file to %s', filepath)

            processed = counter['uploaded'] + counter['existed_before_sync']
            data = {'processed': processed}

            k = Key(bucket)
            k.name = filepath
            wrote = k.set_contents_from_string(json.dumps(data))
            logger.info('Wrote %d for log file %s', wrote, filepath)

        log_result(bucket, prefix, path)
        return counter

    def get_filedatas(self, bucket, path, prefix):

        def _get_filedata(bucket, fullpath, prefix):
            return {
                'md5': md5hash(fullpath),
                'fullpath': fullpath,
                'bucket': bucket,
                'prefix': prefix,
                'on_remote': False,
            }

        if os.path.isdir(path):
            for dirname, _, filenames in os.walk(path):
                for fn in filenames:
                    fullpath = os.path.join(dirname, fn)
                    relpath = os.path.relpath(dirname, path)
                    if relpath == '.':
                        relpath = ''
                    new_prefix = os.path.join(prefix, relpath)
                    yield _get_filedata(bucket, fullpath, new_prefix)
        elif os.path.isfile(path):
            yield _get_filedata(bucket, os.path.abspath(path), prefix)
        else:
            raise NotImplementedError('This script is not able to upload '
                                      'things that not is a normal file or '
                                      'directory.')


class S3lite(pysc.Application):
    """
    Main application class.
    """
    defaults = {
        'config': '/etc/s3lite.yml',
    }

    logger = logger

    def get_argument_parser(self):
        argp = super(S3lite, self).get_argument_parser()
        argp.add_argument('path', type=str, help='Path to file/dir to upload')
        argp.add_argument('bucket',
                          help='s3://bucket/prefix to upload file to')
        return argp

    def main(self):
        s3u = S3Util(self.config['s3']['access_key'],
                     self.config['s3']['secret_key'],
                     minion_id=self.config['minion_id'])

        try:
            parsed = boto.urlparse.urlparse(self.config['bucket'])
            bucket_name, prefix = parsed.netloc, parsed.path
            prefix = prefix[1:]  # prefix must not start with /
            logger.debug('Bucket name: %s, Prefix: %s', bucket_name, prefix)
            bucket = s3u.conn.get_bucket(bucket_name)
        except boto.exception.S3ResponseError as e:
            logger.error('Bucket name %r is bad or does not exist. %r',
                         self.config['bucket'], e, exc_info=True)
            sys.exit(1)
        else:
            counter = s3u.sync(bucket, self.config['path'], prefix)
            logger.info(counter)


if __name__ == "__main__":
    S3lite().run()
