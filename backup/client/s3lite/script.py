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

import os
import logging
import hashlib
import collections

import boto
from boto.s3.key import Key
from boto.s3.connection import S3Connection

import bfs


logger = logging.getLogger(__name__)


def md5hash(filepath):
    md5 = hashlib.md5()
    with open(filepath, 'rb') as f:
        for chunk in iter(lambda: f.read(128 * md5.block_size), b''):
            md5.update(chunk)
    return md5.hexdigest()


class S3Util(object):
    def __init__(self, key_id, secret_key):
        self.conn = S3Connection(key_id, secret_key)
        self.buckets = self.conn.get_all_buckets()

    def upload_file(self, bucket, filepath, prefix):
        filename = os.path.basename(filepath)

        k = Key(bucket)
        k.key = os.path.join(prefix, filename) if prefix else filename
        logger.info('uploading %s to %s,%s', filepath, bucket.name, k.key)

        wrote_bytes = k.set_contents_from_filename(filepath)
        logger.debug('wrote %d bytes', wrote_bytes)
        return wrote_bytes

    def sync(self, bucket, path, prefix=''):
        logger.debug('Prefix to sync: %s', prefix)
        localfiles = self.get_filedatas
        counter = collections.Counter({'uploaded': 0,
                                       'existed_before_sync': 0})

        existed = []
        total_to_process = 0

        for rfile in bucket.list(prefix):
            # etag is usually md5sum of that file
            rmd5 = rfile.etag.strip('"')
            logger.debug('Remote md5 of %r: %r', rfile.name, rmd5)
            cntr = 0
            for lfn in localfiles(bucket, path, prefix):
                cntr += 1
                if rmd5 == unicode(lfn['md5']):
                    logger.warning('%s existed on S3 at %s', lfn['fullpath'],
                                   rfile.name)
                    existed.append(lfn['fullpath'])

            # count once
            if total_to_process == 0:
                total_to_process = cntr

        for lfn in localfiles(bucket, path, prefix):
            if lfn['fullpath'] not in existed:
                self.upload_file(lfn['bucket'], lfn['fullpath'], lfn['prefix'])
                counter['uploaded'] += 1
            else:
                counter['existed_before_sync'] += 1
            processed = counter['uploaded'] + counter['existed_before_sync']
            logger.info('Total %d, processed %d, uploaded %d, existed %d',
                        total_to_process,
                        processed,
                        counter['uploaded'],
                        counter['existed_before_sync'])

        return counter

    def get_filedatas(self, bucket, path, prefix):

        def _get_filedata(bucket, fullpath, prefix):
            return {'md5': md5hash(fullpath),
                    'fullpath': fullpath,
                    'bucket': bucket,
                    'prefix': prefix,
                    'on_remote': False
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


def main():
    import sys

    argp = bfs.common_argparser(default_config_path='/etc/s3lite.yml')
    argp.add_argument('path', type=str, help='Path to file/dir to upload')
    argp.add_argument('bucket', help='s3://bucket/prefix to upload file to')
    args = argp.parse_args()

    util = bfs.Util(args.config, debug=args.log, drop_privilege=False)

    s3u = S3Util(util['s3']['key_id'], util['s3']['secret_key'])

    try:
        parsed = boto.urlparse.urlparse(args.bucket)
        bucket_name, prefix = parsed.netloc, parsed.path
        prefix = prefix[1:]  # prefix must not start with /
        bucket = s3u.conn.get_bucket(bucket_name)
        counter = s3u.sync(bucket, args.path, prefix)
        logger.info(counter)
    except boto.exception.S3ResponseError as e:
        logger.error('Bucket name %r is bad or does not exist.', args.bucket,
                     exc_info=True)
        sys.exit(1)
    except Exception as e:
        logger.error(e, exc_info=True)
        sys.exit(1)


if __name__ == "__main__":
    main()
