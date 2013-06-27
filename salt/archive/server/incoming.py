#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
Process salt archive incoming files.
"""

import os
import logging

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
    source_directory = os.path.join(directory, incoming_sub_directory, category)
    destination_directory = os.path.join(directory, destination_sub_directory,
                                         category)
    for filename in os.listdir(source_directory):
        destination_file = os.path.join(destination_directory, filename)
        source_file = os.path.join(source_directory, filename)
        if not os.path.exists(destination_file):
            logger.info("Move %s file %s to rsync server", category,
                        filename)
            logger.debug("Rename %s to %s", source_file, destination_file)
            os.rename(source_file, destination_file)
        else:
            logger.error("File %s already exists for %s, don't import it",
                         filename, category)
            os.unlink(source_file)


def main():
    import sys
    logging.basicConfig(stream=sys.stderr, level=logging.ERROR)
    move_incoming('/var/lib/salt_archive', 'pip')
    move_incoming('/var/lib/salt_archive', 'mirror')

if __name__ == '__main__':
    main()
