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

import os
import datetime
import pickle
import re
import sys


KEY = "FOOBAR"
SECRET = "BARFOO"
BUCKET = 'my-bucket'
BUCKET_PREFIX = 'my/key/prefix'

def make_file(filename, size):
    match = re.match(r'%s(?P<facility>.+)-(?P<date>[0-9\-_]{19}).tar.xz' % BUCKET_PREFIX, filename)
    if match:
        match = match.groupdict()
        name = match['facility']
        date = datetime.datetime.strptime(match['date'], "%Y-%m-%d-%H_%M_%S")

        return {
            name: {
                'name': filename,
                'size': size,
                'date': date,
                },
            }

    return {}

######################################
# this section is s3-dependant
def create_manifest(path):
    import boto
    s3 = boto.connect_s3(KEY, SECRET)

    # with bucket validation
    bucket = s3.get_bucket(BUCKET,
    # # without bucket validation
    #                        validate=False,
    )

    files = {}

    for key in bucket.list(prefix=BUCKET_PREFIX):
        file = make_file(filename=key.name,
                         size=key.size,)
        # I expect file to have one and only one element
        if file:
            key, value = file.items()[0]
            # update this if it's the first time this appears, or if the date
            # is newer
            if (not key in files) or (value['date'] > files[key]['date']):
                files.update(file)

    pickle.dump(files, open(path, 'wb+'))
    return files
# end of s3-dependant section
#########################################

def get_manifest(path):
    if not os.path.exists(path):
        return create_manifest(path)

    stat = os.stat(path)
    time = datetime.datetime.fromtimestamp(stat.st_mtime)
    now = datetime.datetime.now()

    # check that it's 48 hours or younger
    if ((now - time).total_seconds() / (60 * 60)) >= 48:
        manifest = create_manifest(path)
    else:
        manifest = pickle.load(open(path, 'rb'))

    return manifest

def main(facility=None):
    files = get_manifest("/tmp/s3-backups.pickle")
    if facility not in files:
        print "facility %s backup not found" % facility
        sys.exit(1)

    file = files[facility]
    oldest = datetime.datetime.now() - datetime.timedelta(hours=48)
    if file['date'] < oldest:
        print "file %s has a filename date more than %d hours old" % (file['name'], 48)
        sys.exit(1)

    if not file['size']:
        print "filesize of %s is 0" % (file['name'])
        sys.exit(1)

    print "%s backup OK. Backup date: %s, file size: %d" % (facility, file['date'].strftime("%Y-%m-%d@%H:%M:%S"), file['size'])
    sys.exit(0)

if __name__ == '__main__':
    main(sys.argv[1])
