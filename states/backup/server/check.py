#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
Check that all backup are performed
"""

import os
from UserList import UserList
import datetime
import sys
import logging

logger = logging.getLogger('check_backup')

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
#            self.format_type[self.type], self.compression
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
                    pass
        UserList.__init__(self, data)

def main():
    """
    main loop
    """
    now = datetime.datetime.now()
    max_time = datetime.timedelta(days=1)
    hosts = {}
    backup = BackupDirectory('/var/lib/backup')
    for file in backup:
        try:
            host = hosts[file.hostname]
        except KeyError:
#            hosts[file.hostname] = {}
            host = hosts[file.hostname] = {}
        try:
            name = host[file.name]
        except KeyError:
            name = host[file.name] = {}
        try:
            type = name[file.type]
        except KeyError:
            type = name[file.type] = {}
        type[file.date] = file

    number_backups = 0
    missing_backup = []
    for host in hosts:
        for name in hosts[host]:
            for type in hosts[host][name]:
                logger.debug("Process %s - %s type %s", host, name, type)
                dates = hosts[host][name][type].keys()
                dates.sort()
                latest = hosts[host][name][type][dates[-1]]
                logger.debug("Latest backup %s", latest.date.isoformat())
                if now - latest.date > max_time:
                    logger.debug("Expired backup %s", latest)
                    missing_backup.append('-'.join((host, type)))
                else:
                    logger.debug("Good backup %s", latest)
                    number_backups += 1

    if not missing_backup:
        print 'BACKUP OK - no missing backup|backups={0}'.format(
            number_backups)
        sys.exit(0)
    else:
        print 'BACKUP WARNING - {0} missing backup|backups={1}'.format(
            len(missing_backup), number_backups)
        sys.exit(0)

if __name__ == '__main__':
    logging.basicConfig(level=logging.ERROR, stream=sys.stdout)
    main()
