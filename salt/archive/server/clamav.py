#!/usr/bin/env python

"""
Mirror clamav database files localy
"""

import datetime
from email.utils import parsedate
import logging
import os
import time

import requests

import pysc


logger = logging.getLogger(__name__)


def save(destination, stream, last_modified):
    size = 0
    with open(destination, 'wb') as output:
        for chunk in stream:
            size += len(chunk)
            output.write(chunk)
    logger.debug("Wrote %d bytes to %s", size, destination)
    mtime = time.mktime(last_modified.timetuple())
    os.utime(destination, (mtime, mtime))


class ClamavMirror(pysc.Application):
    defaults = {
        'mirror': 'db.local.clamav.net',
        'files': ('bytecode', 'daily', 'main'),
        'output': '/var/lib/salt_archive/mirror/clamav'
    }

    logger = logger

    def mirror_file(self, filename):
        http_header_size = 'content-length'
        url = 'http://%s/%s' % (self.config['mirror'], filename)
        logger.debug("Going to check %s", url)
        req = requests.get(url, stream=True)
        if not req.ok:
            logger.error("Can't download '%s' code %d reason '%s'",
                         url, req.status_code, req.reason)
            return

        # convert last-modified header string into a datetime instance
        source_timestamp = datetime.datetime(*parsedate(
            req.headers['last-modified'])[:6])
        logger.debug("URL '%s' last modified is '%s'", url, source_timestamp)

        destination = os.path.join(self.config['output'], filename)
        try:
            stat = os.stat(destination)
        except OSError:
            logger.info("File %s don't already exist, download.", filename)
            save(destination, req.iter_content(), source_timestamp)
        else:
            destination_timestamp = datetime.datetime.fromtimestamp(
                stat.st_mtime)
            if destination_timestamp < source_timestamp:
                delta = source_timestamp - destination_timestamp
                logger.info("Local file %s is outdated of %d seconds, download",
                            destination, delta.total_seconds())
                save(destination, req.iter_content(), source_timestamp)
            elif destination_timestamp > source_timestamp:
                logger.warning("URL %s timestamp is '%s' and local %s timestamp"
                               " is '%s': invalid, download again",
                               url, destination, source_timestamp,
                               destination_timestamp)
                save(destination, req.iter_content(), source_timestamp)
            else:
                logger.info("Local and remote file have same timestamp")
                try:
                    remote_size = int(req.headers[http_header_size])
                except KeyError:
                    logger.warning("URL %s didn't returned a %s header, skip"
                                   "size validation.", url, http_header_size)
                else:
                    if stat.st_size == remote_size:
                        logger.info("Local and remote file have same size %d, "
                                    "everything ok", remote_size)
                    else:
                        logger.warning("%s size is %d while %s size is %d, "
                                       "even if both have same last modified,"
                                       " download again", destination,
                                       stat.st_size, url, remote_size)
                        save(destination, req.iter_content(), source_timestamp)

    def main(self):
        for prefix in self.config['files']:
            self.mirror_file(prefix + '.cvd')


if __name__ == "__main__":
    ClamavMirror().run()
