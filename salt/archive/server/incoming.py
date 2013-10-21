#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
Process salt archive incoming files.

Copyright (c) 2013, Bruno Clermont
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met: 

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer. 
2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution. 

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
"""

__author__ = 'Bruno Clermont'
__maintainer__ = 'Bruno Clermont'
__email__ = 'patate@fastmail.cn'

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
