#!/usr/local/nagios/bin/python
# -*- coding: utf-8 -*-
# Use of this is governed by a license that can be found in doc/license.rst.

"""
Nagios plugin to check old or badly uploaded backups with local backup driver.
"""

__author__ = 'Diep Pham'
__maintainer__ = 'Diep Pham'
__email__ = 'favadi@robotinfra.com'

import logging
import os

from check_backup_base import BackupFile, check_backup as base_check, defaults
from pysc import nrpe

log = logging.getLogger('nagiosplugin.backup.client.local')


class LocalBackupFile(BackupFile):
    """
    Local specific backup file checker
    """
    def files(self):
        """
        generator that returns files in the backup server.
        """
        log.info("starting file iteration")
        log.info("prefix %s", self.prefix)

        for archive in os.listdir(self.prefix):
            full_archive = os.path.join(self.prefix, archive)
            if os.path.isfile(full_archive):
                log.info("found file %s".format(archive))
                yield self.make_file(archive,
                                     os.path.getsize(full_archive))


def check_backup(config):
    return base_check(LocalBackupFile, config)


if __name__ == '__main__':
    nrpe.check(check_backup, defaults)
