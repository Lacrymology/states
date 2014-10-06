#!/usr/local/nagios/bin/python
# -*- coding: utf-8 -*-

# Copyright (c) 2013, Bruno Clermont
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
Check that all backup are performed.
"""

__author__ = 'Bruno Clermont'
__maintainer__ = 'Bruno Clermont'
__email__ = 'patate@fastmail.cn'

import datetime
import logging
import os
import sys
from UserList import UserList

import pysc

# NOTE: This doesn't use python's nagiosplugin, but let's put the logs in the
#   same namespace anyways
logger = logging.getLogger('nagiosplugin.backup.server.file')


class BackupFile(object):
    """
    A single backup file.

    :param hostname: host name of the backuped host
    :type hostname: basestring
    :param name: name of the backuped component
    :type name: basestring
    :param date: when the backup happened
    :type date: :class:`datetime.datetime`
    :param compression: which compression type
    :type compression: basestring
    """

    format_type = {
        #'postgresql': 'sql'
        'pip': 'virtualenv',
        'sql': 'postgresql'
    }

    def __init__(self, hostname, name, type, date, compression='.gz'):
        self.hostname = hostname
        self.name = name
        self.type = type
        self.date = date
        self.compression = compression

    @property
    def filename(self):
        """
        return filename of this backup
        """
        return '-'.join((
            self.hostname, self.name, self.type,
            self.date.strftime("%Y-%m-%d-%H_%M_%S"),
            # self.format_type[self.type], self.compression
            self.type, self.compression
        ))

    def __repr__(self):
        return self.filename

    @classmethod
    def from_filename(cls, filename):
        """
        return an instance based on the original filename of the backup
        :param filename: relative filename
        :type filename: string
        :return: instance
        :rtype: :class:`BackupFile`
        """
        prefix, type, compression = filename.split('.')
        items = prefix.split('-')
        format = cls.format_type[type]
        if format not in items:
            msg = "invalid extension (%s) and type in %s" % (compression,
                                                             filename)
            logger.warning(msg)
            raise ValueError(msg)
        hostname = '-'.join(items[0:items.index(format) - 1])
        name = items[items.index(format) - 1]
        date_string = '-'.join(items[items.index(format) + 1:])
        return cls(hostname, name, type,
                   datetime.datetime.strptime(date_string, '%Y-%m-%d-%H_%M_%S'),
                   compression)


class BackupDirectory(UserList):
    """
    List of all backup in a directory

    :param dirname: root directory
    :type dirname: string
    """

    def __init__(self, dirname):
        self.dirname = dirname
        data = []
        for filename in os.listdir(self.dirname):
            absolute_filename = os.path.join(self.dirname, filename)
            if os.path.isfile(absolute_filename):
                try:
                    data.append(BackupFile.from_filename(filename))
                except (ValueError, KeyError):
                    logger.debug("Can't handle %s", absolute_filename)
            else:
                logger.debug("%s isn't a file", absolute_filename)
        UserList.__init__(self, data)


# TODO: switch to pysc.nrpe and nagiosplugin
class CheckBackups(pysc.Application):
    logger = logger
    def main(self):
        """
        main loop
        """
        logger.info("check started")
        now = datetime.datetime.now()
        max_time = datetime.timedelta(hours=36)
        hosts = {}
        backup = BackupDirectory('/var/lib/backup')
        logger.info("iterating directory /var/lib/backup")
        for backup_file in backup:
            try:
                host = hosts[backup_file.hostname]
            except KeyError:
                host = hosts[backup_file.hostname] = {}
            try:
                name = host[backup_file.name]
            except KeyError:
                name = host[backup_file.name] = {}
            try:
                file_type = name[backup_file.type]
            except KeyError:
                file_type = name[backup_file.type] = {}
            file_type[backup_file.date] = backup_file

        logger.debug("Built files map: %s", str(hosts))
        number_backups = 0
        missing_backup = []
        logger.info("Iterating hosts")
        for host in hosts:
            for name in hosts[host]:
                for file_type in hosts[host][name]:
                    logger.debug("Process %s - %s type %s", host, name,
                                 file_type)
                    dates = hosts[host][name][file_type].keys()
                    dates.sort()
                    latest = hosts[host][name][file_type][dates[-1]]
                    logger.debug("Latest backup %s", latest.date.isoformat())
                    if now - latest.date > max_time:
                        logger.debug("Expired backup %s", latest)
                        missing_backup.append('-'.join((host, file_type)))
                    else:
                        logger.debug("Good backup %s", latest)
                        number_backups += 1

        logger.info("check finished")
        logger.debug("missing backups: %s", str(missing_backup))
        if not missing_backup:
            print 'BACKUP OK - no missing backup|backups={0}'.format(
                number_backups)
            sys.exit(0)
        else:
            print 'BACKUP WARNING - {0} missing backup|backups={1}'.format(
                len(missing_backup), number_backups)
            sys.exit(1)

if __name__ == '__main__':
    CheckBackups().run()
