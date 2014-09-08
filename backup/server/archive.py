#!/usr/bin/env python

"""
Copyright (c) 2013, Bruno Clermont
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

__author__ = 'Bruno Clermont'
__maintainer__ = 'Bruno Clermont'
__email__ = 'patate@fastmail.cn'

import tarfile
import os
import datetime
import logging
import logging.config
import bfs

logger = logging.getLogger('backup-archive')

def archive_directory(root_directory='/var/lib/backup'):
    logger.debug("Start to archive %s", root_directory)
    for filename in os.listdir(root_directory):
        absolute_filename = os.path.join(root_directory, filename)
        if os.path.isdir(absolute_filename):
            logger.debug("found directory %s", absolute_filename)
            archive_filename = os.path.join(root_directory,
                                            '{0}-{1}.tar'.format(
                                                filename,
                                                datetime.datetime.now().isoformat()
                                            ))
            archive = tarfile.open(archive_filename, 'w')
            archive.add(absolute_filename, filename)
            archive.close()
            logger.info("Archive %s created from %s", absolute_filename)

@bfs.profile(log=logger)
def main():
    logging.config.fileConfig('/etc/backup-archive.conf')
    archive_directory()

if __name__ == '__main__':
    main()
