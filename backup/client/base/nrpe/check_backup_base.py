# -*- coding: utf-8 -*-

# Copyright (c) 2014, Tomas Neme
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
Common code for backup file checking nrpe plugins
"""

__author__ = 'Tomas Neme'
__maintainer__ = 'Tomas Neme'
__email__ = 'lacrymology@gmail.com'

import datetime
import logging
import re
import nagiosplugin
import pysc

log = logging.getLogger('nagiosplugin.backup.client.base')
CACHE_TIMEOUT = 15


class BackupFile(nagiosplugin.Resource):
    def __init__(self, config, facility):
        log.debug("Reading config file: %s", config)
        self.config = pysc.unserialize_yaml(config)

        self.prefix = self.config['backup']['prefix']

        self.facility = facility

    def probe(self):
        log.info("BackupFile probe started")
        log.info("Probe backup for facility: %s", self.facility)

        files = {}
        log.debug("Searching keys with prefix %s", self.prefix)
        for file in self.files():
            key, value = file.items()[0]
            # update this if it's the first time this appears, or if the date
            # is newer
            if (key not in files) or (value['date'] > files[key]['date']):
                log.debug("Adding file to return dict")
                files.update(file)
        log.info("%s on S3? %s", self.facility,
                 str(not files.get(self.facility, None) is None))

        backup_file = files.get(self.facility, {
            'date': datetime.datetime.fromtimestamp(0),
            'size': 0,
        })

        age_metric = nagiosplugin.Metric(
            'age',
            (datetime.datetime.now() - backup_file['date']).total_seconds() /
            (60*60),
            min=0)
        size_metric = nagiosplugin.Metric('size', backup_file['size'], min=0)

        log.info("BackupFile.probe finished")
        log.debug("returning age: %s, size: %s", age_metric, size_metric)
        return [age_metric, size_metric]

    def files(self):
        """
        Subclasses must implement this method to create the list of files using
        `make_file(name, size)`
        """
        raise NotImplementedError()

    def make_file(self, filename, size):
        log.info("Creating file dict for: %s(%sB)", filename, size)
        match = re.match(r'(?P<facility>.+)-(?P<date>[0-9\-_]{19})',
                         filename)
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
                }
            }
        else:
            log.warn("Filename didn't match regexp.\
                     This file shouldn't be here: %s", filename)

        return {}


def check_backup(Collector, config):
    return (
        Collector(
            config['config'],
            config['facility'],
        ),
        nagiosplugin.ScalarContext('age',
                                   config['warning'],
                                   config['warning']),
        nagiosplugin.ScalarContext('size', "1:", "1:"),
    )


defaults = {
    'warning': '48',
    'config': '/etc/nagios/backup.yml',
}
