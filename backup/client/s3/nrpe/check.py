#! /usr/bin/env python

# -*- coding: utf-8 -*-

"""
.. module:: 
   :platform: Unix
   :synopsis: TODO

.. moduleauthor:: Tomas Neme <lacrymology@gmail.com>

"""
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
