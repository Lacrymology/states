#!/usr/local/nagios/bin/python
# -*- coding: utf-8 -*-

# Copyright (c) 2014, Tomas Neme
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice, this
#    list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
# ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

"""
Nagios plugin to check old or badly uploaded backups to an s3 bucket..
"""

__author__ = 'Tomas Neme'
__maintainer__ = 'Tomas Neme'
__email__ = 'lacrymology@gmail.com'

import logging
import os

import boto

from check_backup_base import BackupFile, main

log = logging.getLogger('nagiosplugin')


class S3BackupFile(BackupFile):
    """
    S3-specific backup file checker
    """
    def __init__(self, *args, **kwargs):
        super(S3BackupFile, self).__init__(*args, **kwargs)
        self.key = self.config.get('s3', 'key')
        self.secret = self.config.get('s3', 'secret')
        self.bucket = self.config.get('s3', 'bucket')

    def files(self):
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
        for key in bucket.list(prefix=self.prefix.strip('/') + '/', delimiter='/'):
            log.debug("Processing key %s", key.name)
            if isinstance(key, boto.s3.prefix.Prefix):
                # prefix is a concept same as "directory"
                log.debug('%s is a Prefix, skipping ...', key.name)
                continue
            file = self.make_file(os.path.basename(key.name), key.size)
            # I expect file to have one and only one element
            if file:
                yield file


if __name__ == '__main__':
    main(S3BackupFile)
