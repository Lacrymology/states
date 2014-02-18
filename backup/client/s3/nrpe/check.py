#! /usr/bin/env python

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

import argparse
import datetime
import logging
import os
import pickle
import re
import nagiosplugin
from ConfigParser import SafeConfigParser as ConfigParser

log = logging.getLogger('nagiosplugin')

class BackupFile(nagiosplugin.Resource):
    def __init__(self, config, facility, manifest, age):
        self.config = ConfigParser()
        log.debug("Reading config file: %s", config)
        self.config.read(config)

        self.facility = facility
        self.manifest = manifest
        self.age = age

        self.prefix = self.config.get('backup', 'path')

    def probe(self):
        log.info("Probe backup for facility: %s", self.facility)
        files = self.get_manifest()

        log.info("%s in manifest? %s", self.facility,
                 str(not files.get(self.facility, None) is None))
        file = files.get(self.facility, {
            'date': datetime.datetime.fromtimestamp(0),
            'size': 0,
        })

        age_metric = nagiosplugin.Metric(
            'age',
            (datetime.datetime.now() - file['date']).total_seconds() / (60*60),
            min=0)
        size_metric = nagiosplugin.Metric('size', file['size'], min=0)

        log.debug("returning age: %s, size: %s", age_metric, size_metric)
        return [age_metric, size_metric]

    def get_manifest(self):
        log.info('manifest requested')
        if not os.path.exists(self.manifest):
            log.debug("manifest file doesn't exist")
            return self.create_manifest()

        stat = os.stat(self.manifest)
        time = datetime.datetime.fromtimestamp(stat.st_mtime)
        now = datetime.datetime.now()
        log.debug("Manifest file mtime: %s", time.strftime("%Y-%m-%d-%H_%M_%S"))

        # check that it's self.age hours or younger
        if ((now - time).total_seconds() / (60 * 60)) >= self.age:
            log.debug("manifest file is too old")
            return self.create_manifest()
        else:
            log.debug("returning cached manifest file")
            return pickle.load(open(self.manifest, 'rb'))

    def files(self):
        """
        Subclasses must implement this method to create the list of files using
        `make_file(name, size)`
        """
        raise NotImplementedError()

    def create_manifest(self):
        """
        Creates the manifest file from the s3 bucket. This is the only part of
        this class that is s3-dependant
        """
        log.info("Creating new manifest file")
        files = {}

        log.debug("Searching keys with prefix %s", self.prefix)
        for file in self.files():
            log.debug("File created")
            key, value = file.items()[0]
            # update this if it's the first time this appears, or if the date
            # is newer
            if (not key in files) or (value['date'] > files[key]['date']):
                log.debug("Adding file to return dict")
                files.update(file)

        log.debug("dumping files: %s", str(files))
        pickle.dump(files, open(self.manifest, 'wb+'))
        return files

    def make_file(self, name, size):
        log.info("Creating file dict for: %s(%sB)", name, size)
        match = re.match(r'(?P<facility>.+)-(?P<date>[0-9\-_]{19}).tar.xz', name)
        if match:
            match = match.groupdict()
            log.debug("Key matched regexp, facility: %s, date: %s",
                      match['facility'], match['date'])
            name = match['facility']
            date = datetime.datetime.strptime(match['date'],
                                              "%Y-%m-%d-%H_%M_%S")

            return {
                name: {
                    'name': name,
                    'size': size,
                    'date': date,
                    },
                }
        else:
            log.warn("Filename didn't match regexp. This file shouldn't be here: %s",
                     name)

        return {}


class S3BackupFile(BackupFile):
    """
    S3-specific backup file checker
    """
    def __init__(self, *args, **kwargs):
        super(S3BackupFile, self).__init__(*args, **kwargs)
        self.key = self.config.get('s3','key')
        self.secret = self.config.get('s3', 'secret')
        self.bucket = self.config.get('s3', 'bucket')


    def files(self):
        import boto
        s3 = boto.connect_s3(self.key, self.secret)

        log.debug("searching bucket %s", self.bucket)
        # with bucket validation
        bucket = s3.get_bucket(self.bucket,
        # # without bucket validation, which is faster and cheaper, but can
        # # cause unexpected errors later
        #                        validate=False,
        )
        for key in bucket.list(prefix=self.prefix):
            log.debug("Processing key %s", key)
            file = self.make_file(os.path.basename(key.name), key.size)
            # I expect file to have one and only one element
            if file:
                yield file


@nagiosplugin.guarded
def main():
    argp = argparse.ArgumentParser(
        description=__doc__,
        formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    argp.add_argument('facility', help='facility name to check backups for')
    argp.add_argument('-w', '--warning', metavar='HOURS', default='48',
                      help='Emit a warning if a backup file is older than HOURS')
    argp.add_argument('-c', '--config', metavar="PATH",
                      default='/etc/nagios/backup.conf')
    argp.add_argument('-m', '--manifest',
                      help='s3 backup files manifest location',
                      default='/var/lib/nagios/s3.backup.manifest.pickle')
    argp.add_argument('--timeout', default=None)
    argp.add_argument('-v', '--verbose', action='count', default=0)

    args = argp.parse_args()

    check = nagiosplugin.Check(
        S3BackupFile(args.config,
                     args.facility,
                     args.manifest,
                     int(args.warning)),
        nagiosplugin.ScalarContext('age', args.warning, args.warning),
        nagiosplugin.ScalarContext('size', "1:", "1:"),
    )
    check.main(args.verbose, timeout=args.timeout)

if __name__ == '__main__':
    main()
