#!/usr/bin/env python
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
Process salt archive incoming files.
"""

__author__ = 'Bruno Clermont'
__maintainer__ = 'Bruno Clermont'
__email__ = 'patate@fastmail.cn'

import os
import subprocess
import tempfile
import logging
import pysc

logger = logging.getLogger(__name__)


def move_incoming(directory, category, incoming_sub_directory='incoming',
                  destination_sub_directory=''):
    """
    Move an archive from incoming to production.
    :param directory: root of salt archives
    :param category: pip or mirror
    :param incoming_sub_directory: incoming root sub-directory
    :param destination_sub_directory: outgoing root sub-directory
    """
    source_directory = os.path.join(directory, incoming_sub_directory, category) + os.sep
    destination_directory = os.path.join(directory, destination_sub_directory,
                                         category)

    # get a list of currently open files to avoid transfering it, This assumes
    # that once a file is released it isn't opened again
    lsof = subprocess.Popen(('lsof', '-Fn', '+D', source_directory),
                            stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    # lsof outputs n<filename>, so lose that
    filtered = [line[1:] for line in lsof.communicate()[0].split('\n') if line.startswith('n')]
    # get paths relative to source_directory
    filtered = [line[len(source_directory):] for line in filtered]
    logging.debug("excluding open files: %s", filtered)

    # write files to be excluded to a tmp file for rsync to read
    exclude = tempfile.NamedTemporaryFile()
    exclude.file.write("\n".join(filtered))
    exclude.file.close()

    rsync = subprocess.Popen(('rsync',
                              '-a',
                              '--ignore-existing',     # don't overwrite
                              '--remove-source-files', # delete moved files
                              '--exclude-from=%s' % exclude.name, # exclude open
                              '--prune-empty-dirs',    # don't create empty dirs
                              source_directory,
                              destination_directory),
                             stdout=subprocess.PIPE, stderr=subprocess.PIPE)

    out, err = rsync.communicate()
    if out:
        logging.debug("rsync stdout: %s", out)
    if err:
        logging.error("Got things in stderr: %s", err)

    # sadly there doesn't seem to be a way to easily delete files filtered by
    # the --ignore-existing bit
    for path, dirs, files in os.walk(source_directory, topdown=False):
        to_remove = []
        for file in files:
            filename = os.path.join(path, file)
            if filename[len(source_directory):] not in filtered:
                os.unlink(filename)
                to_remove.append(file)

        files[:] = [f for f in files if f not in to_remove]

        if (path != source_directory) and not (dirs or files):
            os.rmdir(path)

@pysc.profile(log=logger)
def main():
    import sys
    logging.basicConfig(stream=sys.stderr, level=logging.ERROR)
    move_incoming('/var/lib/salt_archive', 'pip')
    move_incoming('/var/lib/salt_archive', 'mirror')

if __name__ == '__main__':
    main()
