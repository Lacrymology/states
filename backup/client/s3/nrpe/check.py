#! /usr/bin/env python

# -*- coding: utf-8 -*-

"""
Nagios plugin to check old or badly uploaded backups to an s3 bucket..

Copyright (c) 2014, Tomas Neme
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
"""

__author__ = 'Tomas Neme'
__maintainer__ = 'Tomas Neme'
__email__ = 'lacrymology@gmail.com'

import argparse
import datetime
import os
import pickle
import re
import nagiosplugin

class BackupFile(nagiosplugin.Resource):
    def __init__(self, facility, manifest, age, key, secret, bucket, prefix):
        self.facility = facility
        self.manifest = manifest
        self.key = key
        self.secret = secret
        self.bucket = bucket
        self.prefix = prefix
        self.age = age

    def probe(self):
        files = self.get_manifest()

        file = files.get(self.facility, {
            'date': datetime.datetime.fromtimestamp(0),
            'size': 0,
        })

        return [
            nagiosplugin.Metric('age', (datetime.datetime.now() - file['date']).total_seconds() / (60*60), min=0),
            nagiosplugin.Metric('size', file['size'], min=0),
            ]

    def get_manifest(self):
        if not os.path.exists(self.manifest):
            return self.create_manifest()

        stat = os.stat(self.manifest)
        time = datetime.datetime.fromtimestamp(stat.st_mtime)
        now = datetime.datetime.now()

        # check that it's self.age hours or younger
        if ((now - time).total_seconds() / (60 * 60)) >= self.age:
            return self.create_manifest()
        else:
            return pickle.load(open(self.manifest, 'rb'))

    def create_manifest(self):
        """
        Creates the manifest file from the s3 bucket. This is the only part of
        this class that is s3-dependant
        """
        import boto
        s3 = boto.connect_s3(self.key, self.secret)

        # with bucket validation
        bucket = s3.get_bucket(self.bucket,
        # # without bucket validation, which is faster and cheaper, but can
        # # cause unexpected errors later
        #                        validate=False,
        )

        files = {}

        for key in bucket.list(prefix=self.prefix):
            file = self.make_file(key)
            # I expect file to have one and only one element
            if file:
                key, value = file.items()[0]
                # update this if it's the first time this appears, or if the date
                # is newer
                if (not key in files) or (value['date'] > files[key]['date']):
                    files.update(file)

        pickle.dump(files, open(self.manifest, 'wb+'))
        return files

    def make_file(self, key):
        match = re.match(r'%s(?P<facility>.+)-(?P<date>[0-9\-_]{19}).tar.xz' % self.prefix, key.name)
        if match:
            match = match.groupdict()
            name = match['facility']
            date = datetime.datetime.strptime(match['date'], "%Y-%m-%d-%H_%M_%S")

            return {
                name: {
                    'name': key.name,
                    'size': key.size,
                    'date': date,
                    },
                }

        return {}

@nagiosplugin.guarded
def main():
    argp = argparse.ArgumentParser(description=__doc__,
                                   formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    argp.add_argument('facility', help='facility name to check backups for')
    argp.add_argument('-w', '--warning', metavar='HOURS', default='48',
                      help='Emit a warning if a backup file is older than HOURS')
    argp.add_argument('-k', '--key', help='s3 key', required=True)
    argp.add_argument('-s', '--secret', help='s3 secret', required=True)
    argp.add_argument('-b', '--bucket', help='s3 bucket name', required=True)
    argp.add_argument('-p', '--prefix', help='s3 key name prefix (directory)',
                      default='')
    argp.add_argument('-m', '--manifest',
                      help='s3 backup files manifest location',
                      default='/tmp/s3.backup.manifest.pickle')
    argp.add_argument('--timeout', default=None)
    argp.add_argument('-v', '--verbose', action='count', default=0)

    args = argp.parse_args()
    check = nagiosplugin.Check(
        BackupFile(args.facility,
                   args.manifest,
                   int(args.warning),
                   args.key,
                   args.secret,
                   args.bucket,
                   args.prefix),
        nagiosplugin.ScalarContext('age', args.warning, args.warning),
        nagiosplugin.ScalarContext('size', "1:", "1:"),
    )
    check.main(args.verbose, timeout=args.timeout)

if __name__ == '__main__':
    main()
