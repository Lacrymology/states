#!/usr/bin/env python

__author__ = 'Bruno Clermont'
__maintainer__ = 'Bruno Clermont'
__email__ = 'patate@fastmail.cn'

import tarfile
import os
import datetime
import logging
import logging.config

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

def main():
    logging.config.fileConfig('/etc/backup-archive.conf')
    archive_directory()

if __name__ == '__main__':
    main()
