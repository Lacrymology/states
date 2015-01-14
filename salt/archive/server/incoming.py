#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Use of this source code is governed by a BSD license that can be
# found in the doc/license.rst file.

"""
Process salt archive incoming files.
"""

__author__ = 'Bruno Clermont'
__maintainer__ = 'Bruno Clermont'
__email__ = 'bruno@robotinfra.com'

import logging
import os
import subprocess
import tempfile

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
    source_directory = os.path.join(directory,
                                    incoming_sub_directory,
                                    category) + os.sep
    destination_directory = os.path.join(directory, destination_sub_directory,
                                         category)

    # get a list of currently open files to avoid transfering it, This assumes
    # that once a file is released it isn't opened again
    lsof = subprocess.Popen(('lsof', '-Fn', '+D', source_directory),
                            stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    # lsof outputs n<filename>, so lose that
    filtered = [line[1:] for line in lsof.communicate()[0].split('\n')
                if line.startswith('n')]
    # get paths relative to source_directory
    filtered = [line[len(source_directory):] for line in filtered]
    logging.debug("excluding open files: %s", filtered)

    # write files to be excluded to a tmp file for rsync to read
    exclude = tempfile.NamedTemporaryFile()
    exclude.file.write("\n".join(filtered))
    exclude.file.close()

    rsync = subprocess.Popen(('rsync',
                              '-a',
                              '--ignore-existing',      # don't overwrite
                              '--remove-source-files',  # delete moved files
                              # exclude open
                              '--exclude-from=%s' % exclude.name,
                              '--prune-empty-dirs',  # don't create empty dirs
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


class Incoming(pysc.Application):
    logger = logger

    def main(self):
        move_incoming('/var/lib/salt_archive', 'pip')
        move_incoming('/var/lib/salt_archive', 'mirror')

        try:
            subprocess.call('/usr/local/bin/salt_archive_set_owner_mode.sh')
        except Exception as e:
            logger.error(e)

if __name__ == '__main__':
    Incoming().run()
