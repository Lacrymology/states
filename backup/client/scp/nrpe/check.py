#!/usr/local/nagios/bin/python
# -*- coding: utf-8 -*-

# Copyright (c) 2014, Tomas Neme
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
Nagios plugin to check old or badly uploaded backups done via scp..
"""

__author__ = 'Tomas Neme'
__maintainer__ = 'Tomas Neme'
__email__ = 'lacrymology@gmail.com'

import logging
import os
import pwd

import paramiko

from check_backup_base import BackupFile, main

log = logging.getLogger('nagiosplugin')


class SCPBackupFile(BackupFile):
    """
    SCP-specific backup file checker

    Expects an [ssh] section in the config file which should contain the
    connection arguments. 'hostname' is the only mandatory parameter, but
    there's a number of optional parameters including username, password, or the
    private key to use for the connection. Read `paramiko.SSHClient.connect`
    documentation for more details.
    Two aditional boolean setting keys are accepted:
    - `load_system_host_keys`: boolean. Default True. If True, the current
      user's `~/.ssh/known_hosts` file will be loaded.
    - `host_key_auto_add`: boolean. Default False. If True, any unknown host
      keys will be automatically added to known_hosts
    """
    def __init__(self, *args, **kwargs):
        super(SCPBackupFile, self).__init__(*args, **kwargs)
        self.kwargs = self.config['ssh']
        # this is mainly to get an error if the 'hostname' config is missing
        self.hostname = self.config['ssh']['hostname']
        self.load_system_host_keys = self.kwargs.pop('load_system_host_keys',
                                                     True)
        self.host_key_auto_add = self.kwargs.pop('host_key_auto_add', False)
        # convert port to an int
        if 'port' in self.kwargs:
            log.debug('converting port %s to int', self.kwargs['port'])
            self.kwargs['port'] = int(self.kwargs['port'])

        self.pwd = self.prefix

    def files(self):
        """
        generator that returns files in the backup server. Notice that this
        preprocesses the whole list of filenames before yielding to avoid asking
        fstat for older backups (it makes sure it has the newest ones only)
        """
        log.info("starting file iteration")
        ssh = paramiko.SSHClient()

        if self.load_system_host_keys:
            log.debug('loading system host keys')
            ssh.load_system_host_keys()
        if self.host_key_auto_add:
            log.debug('setting host key policy to auto add')
            ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())

        sshconf = paramiko.SSHConfig()
        # paramiko uses 'USER' environment var to parsing %u, %r
        # when nrpe daemon run the check, that var is not set and results in
        # 'None' user, set it before parsing config file.
        local_user = pwd.getpwuid(os.getuid()).pw_name
        os.environ['USER'] = os.environ.get('USER', local_user)
        with open('/etc/ssh/ssh_config') as f:
            sshconf.parse(f)

        # paramiko wrongly parses %u/%r@%h as it use same value for %u and %r
        # replace %r with the configured username
        self.kwargs['key_filename'] = (
            path.replace(local_user + '@', self.kwargs['username'] + '@')
            for path in sshconf.lookup(self.hostname)['identityfile']
            if '@' in os.path.basename(path))

        log.info("connecting to %s", self.hostname)
        log.debug("kwargs: %s", str(self.kwargs))
        ssh.connect(**self.kwargs)
        log.debug("opening sftp")
        ftp = ssh.open_sftp()
        log.debug("chdir %s", self.pwd)
        try:
            ftp.chdir(self.pwd)
        except IOError, e:
            log.error("Error going to directory %s: %s", self.pwd, e)
            return

        # optimization. To avoid running fstat for every backup file, I filter
        # out to only test the newest backup for each facility
        files = {}
        log.debug("running ls")
        for file in ftp.listdir():
            log.debug('processing %s', file)

            f = self.make_file(file, None)
            if not f:
                log.debug('skipping')
                continue
            key, value = f.items()[0]
            # we may want to run fstat on this file later on
            f[key]['filename'] = file
            # this code is taken from BackupFile.create_manifest, it keeps only
            # the newest file for each facility
            if (not key in files) or (value['date'] > files[key]['date']):
                log.debug('first or newer.')
                files.update(f)
            else:
                log.debug('was old')

        # now fetch fstat for each file, and yield them
        for k, f in files.items():
            log.debug('getting fstat for %s', f['filename'])
            filestat = ftp.stat(f['filename'])
            f['size'] = filestat.st_size
            yield {k: f}


if __name__ == '__main__':
    main(SCPBackupFile)
