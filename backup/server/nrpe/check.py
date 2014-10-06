#!/usr/local/nagios/bin/python
# -*- coding: utf-8 -*-

# Copyright (c) 2013, Bruno Clermont
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice,
#    this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

"""
Check that all backup are performed.
"""

__author__ = 'Bruno Clermont'
__maintainer__ = 'Bruno Clermont'
__email__ = 'patate@fastmail.cn'

import datetime
import logging
import os
from UserList import UserList

import nagiosplugin

from pysc import nrpe

# NOTE: This doesn't use python's nagiosplugin, but let's put the logs in the
#   same namespace anyways
log = logging.getLogger('nagiosplugin.backup.server.file')


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
        # 'postgresql': 'sql'
        'pip': 'virtualenv',
        'sql': 'postgresql'
    }

    def __init__(self, hostname, name, fmt, date, compression='.gz'):
        self.hostname = hostname
        self.name = name
        self.type = fmt
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
        prefix, fmt_name, compression = filename.split('.')
        items = prefix.split('-')
        fmt = cls.format_type[fmt_name]
        if fmt not in items:
            msg = "invalid extension (%s) and type in %s" % (compression,
                                                             filename)
            log.warning(msg)
            raise ValueError(msg)
        hostname = '-'.join(items[0:items.index(fmt) - 1])
        name = items[items.index(fmt) - 1]
        date_string = '-'.join(items[items.index(fmt) + 1:])
        return cls(hostname, name, fmt_name,
                   datetime.datetime.strptime(date_string,
                                              '%Y-%m-%d-%H_%M_%S'),
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
                    log.debug("Can't handle %s", absolute_filename)
            else:
                log.debug("%s isn't a file", absolute_filename)
        UserList.__init__(self, data)


class MissingBackupsContext(nagiosplugin.Context):
    def describe(self, metric):
        missing, total = metric.value
        return '{0} missing backups|backups={1}'.format(
            len(missing), total)

    def evaluate(self, metric, resource):
        missing, _ = metric.value
        if len(missing) > 0:
            state = nagiosplugin.state.Critical
        else:
            state = nagiosplugin.state.Ok
        return nagiosplugin.Result(state, metric=metric)


class Backups(nagiosplugin.Resource):
    def __init__(self, max_hours=36, *args, **kwargs):
        super(Backups, self).__init__(*args, **kwargs)
        self.max_hours = max_hours

    def probe(self):
        log.info("check started")
        now = datetime.datetime.now()
        max_time = datetime.timedelta(hours=self.max_hours)
        hosts = {}
        backup_dir = self.config['backup_directory']
        backup = BackupDirectory(backup_dir)
        log.info("iterating directory %s", backup_dir)
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

        log.debug("Built files map: %s", str(hosts))
        number_backups = 0
        missing_backup = []
        log.info("Iterating hosts")
        for host in hosts:
            for name in hosts[host]:
                for file_type in hosts[host][name]:
                    log.debug("Process %s - %s type %s", host, name,
                              file_type)
                    dates = hosts[host][name][file_type].keys()
                    dates.sort()
                    latest = hosts[host][name][file_type][dates[-1]]
                    log.debug("Latest backup %s", latest.date.isoformat())
                    if now - latest.date > max_time:
                        log.debug("Expired backup %s", latest)
                        missing_backup.append('-'.join((host, file_type)))
                    else:
                        log.debug("Good backup %s", latest)
                        number_backups += 1

        log.info("check finished")
        log.debug("missing backups: %s", str(missing_backup))
        yield nagiosplugin.Metric('missing', (missing_backup, number_backups))


def check_backups(config):
    return (
        Backups(max_hours=config['max_hours']),
        MissingBackupsContext('missing'),
    )

if __name__ == '__main__':
    nrpe.check(check_backups, {
        'max_hours': 36,
        'backup_dir': '/var/lib/backup'
    })
