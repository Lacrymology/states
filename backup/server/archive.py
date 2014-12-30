#!/usr/bin/env python

# Use of this source code is governed by a BSD license that can be
# found in the doc/license.rst file.

__author__ = 'Bruno Clermont'
__maintainer__ = 'Bruno Clermont'
__email__ = 'bruno@robotinfra.com'

"""
Create tar ball from backup'ed directories, for past archive.
"""

import datetime
import os
import logging
import logging.config
import tarfile

import pysc

logger = logging.getLogger('backup-archive')


class BackupArchiver(pysc.Application):
    defaults = {
        'archive_root': '/var/lib/backup',
    }

    def main(self):
        root_directory = self.config['archive_root']
        logger.debug("Start to archive %s", root_directory)
        for filename in os.listdir(root_directory):
            absolute_filename = os.path.join(root_directory, filename)
            if os.path.isdir(absolute_filename):
                logger.debug("found directory %s", absolute_filename)
                archive_filename = os.path.join(
                    root_directory,
                    '{0}-{1}.tar'.format(
                        filename,
                        datetime.datetime.now().isoformat()
                    )
                )
                archive = tarfile.open(archive_filename, 'w')
                archive.add(absolute_filename, filename)
                archive.close()
                logger.info("Archive %s created from %s",
                            archive_filename, absolute_filename)


if __name__ == '__main__':
    BackupArchiver().run()
