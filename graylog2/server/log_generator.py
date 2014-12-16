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
Log generator to stress GELF server.
"""

__author__ = 'Bruno Clermont'
__maintainer__ = 'Bruno Clermont'
__email__ = 'bruno@robotinfra.com'

import logging
import logging.config
import multiprocessing
import threading
import optparse

logger = logging.getLogger()


def logging_config_dict(server_address):
    """
     that will
    log on remote server but show in the console this script debugging.

    :param server_address: IP or hostname of GELF server
    :type server_address: string
    :return: func:`logging.config.DictConfig` compatible configuration
    :rtype: dict
    """
    return {
        'version': 1,
        'disable_existing_loggers': True,
        'formatters': {
            'message_only': {
                'format': '%(message)s'
            },
            'timestamp_message': {
                'format': '%(asctime)-15s %(message)s'
            }
        },
        'handlers': {
            'gelf': {
                'level': 'NOTSET',
                'class': 'graypy.handler.GELFHandler',
                'host': server_address,
                'formatter': 'message_only'
            },
            'console': {
                'level': 'NOTSET',
                'class': 'logging.StreamHandler',
                'formatter': 'timestamp_message'
            }
        },
        'loggers': {
            'generator': {
                'level': 'DEBUG',
                'propagate': False,
                'handlers': ['gelf']
            },
        },
        'root': {
            'handlers': ['console'],
            'propagate': True,
            'level': 'NOTSET'
        }
    }


class LoggerThread(threading.Thread):
    """
    Logger thread.

    :param process_name: parent process name
    :type process_name: string
    """

    def __init__(self, process_name):
        self.process_name = process_name
        threading.Thread.__init__(self)

    def run(self):
        """
        loop logging
        """
        remote_logger = logging.getLogger('generator')
        while True:
            remote_logger.debug("%s: %s", self.process_name, self.name)
                                # exc_info=True, extra=self.__dict__)


class LoggerProcess(multiprocessing.Process):
    """
    Logger process.

    :param server_address: IP/Hostname of log server
    :type server_address: string
    :param number_threads: number of thread to run
    :type number_threads: int
    """

    def __init__(self, server_address, number_threads):
        self.server_address = server_address
        self.number_threads = number_threads
        logging.config.dictConfig(logging_config_dict(server_address))
        multiprocessing.Process.__init__(self)

    def run(self):
        """
        launch threads
        """
        threads = []
        for i in range(0, self.number_threads):
            threads.append(LoggerThread(self.name))
        # launch them
        for thread in threads:
            thread.start()
        print "Launched %d threads, to stop hit CTRL-C" % self.number_threads
        for thread in threads:
            thread.join()
        return


def launch_loggers(server, number_process, number_threads):
    """
    Launch processes.

    :param server: IP/Hostname log server
    :type server: string
    :param number_process: number of process to launch
    :type number_process: int
    :param number_threads: number of threads per process
    :type number_threads: int
    """
    processes = []
    for i in range(0, number_process):
        processes.append(LoggerProcess(server, number_threads))
    # launch them
    for process in processes:
        process.start()
    print "Launched %d processes, to stop hit CTRL-C" % number_process
    # wait pretty much for ever or until CTRL-C is hit
    try:
        for proc in processes:
            proc.join()
    except KeyboardInterrupt:
        for proc in processes:
            if proc.is_alive():
                proc.terminate()


def main():
    """
    main loop
    """
    parser = optparse.OptionParser()
    parser.add_option('-p', '--process', dest='process', type='int',
                      help='Number of processes')
    parser.add_option('-t', '--threads', dest='threads', type='int',
                      help='Number of threads per process')
    parser.add_option('-s', '--server', dest='server', type='str',
                      help='Server address')
    (options, args) = parser.parse_args()
    if not options.process:
        parser.error("missing number of process")
    if not options.threads:
        parser.error("missing number of threads")
    if not options.server:
        parser.error("missing server address")
    launch_loggers(options.server, options.process, options.threads)

if __name__ == '__main__':
    main()
