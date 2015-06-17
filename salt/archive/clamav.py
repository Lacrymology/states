#!/usr/bin/env python
# -*- coding: utf-8 -*-
# {{ salt['pillar.get']('message_do_not_modify') }}
# Usage of this is governed by a license that can be found in doc/license.rst

"""
Mirror clamav database files localy
"""

import datetime
from email.utils import parsedate
import grp
import logging
import os
import pwd
import subprocess as spr
import tempfile
import time

import requests

import pysc


logger = logging.getLogger(__name__)
CHUNK_SIZE = 1024
MAX_RETRIES = 5
SLEEP_PERIOD = 30


def _new_request(url, times=MAX_RETRIES, sleep=SLEEP_PERIOD):
    '''
    Download an ``url`` and retry ``times`` each after ``sleep``
    if there is failure.
    '''
    req = None
    exception = None
    for i in xrange(times):
        try:
            req = requests.get(url, stream=True, timeout=10)
            req.raise_for_status()
            return req
        except requests.exception.HTTPError:
            logger.info('Retrying %d/%d times in next %d seconds',
                        i, times, sleep)
            time.sleep(sleep)

    if req:
        logger.error("Can't download '%s' code %d reason '%s'",
                     url, req.status_code, req.reason)
    else:
        logger.error("Can't download '%s'. Got exception %s.",
                     url, exception)
    return False


def save(local, url, last_modified, owner, group,
         times=MAX_RETRIES, sleep=SLEEP_PERIOD):
    size = 0
    tmp = tempfile.NamedTemporaryFile(delete=False)

    for i in xrange(times):
        try:
            logger.debug("Create temp file %s", tmp.name)
            with open(tmp.name, 'wb') as output:
                stream = _new_request(url).iter_content(CHUNK_SIZE)
                for chunk in stream:
                    size += len(chunk)
                    output.write(chunk)
            logger.debug("Wrote %d bytes to %s", size, tmp.name)
            logger.debug("Move %s to %s", tmp.name, local)
            os.chown(tmp.name,
                     pwd.getpwnam(owner).pw_uid,
                     grp.getgrnam(group).gr_gid,
                     )
            logger.info(local)
            os.rename(tmp.name, local)
            mtime = time.mktime(last_modified.timetuple())
            os.utime(local, (mtime, mtime))
            return
        except requests.exceptions.Timeout:
            logger.info('Timeout, retry: %s %d/%d times in next %d seconds',
                        url, i, times, sleep)
            if i == times - 1:
                raise
            time.sleep(sleep)


class ClamavMirror(pysc.Application):
    defaults = {
        'files': ('bytecode', 'daily', 'main'),
        'output': '/var/lib/salt_archive/mirror/clamav',
        'owner': 'root',
        'group': 'salt_archive',
        'lock': '/var/run/clamav_mirror.pid',
        'config': '/etc/salt-archive-clamav.yml',
    }

    logger = logger

    def mirror_file(self, filename):
        http_header_size = 'content-length'
        url = 'http://%s/%s' % (self.config['mirror'], filename)
        logger.debug("Going to check %s", url)

        req = _new_request(url)
        if not req:
            return

        # convert last-modified header string into a datetime instance
        source_timestamp = datetime.datetime(*parsedate(
            req.headers['last-modified'])[:6])
        logger.debug("URL '%s' last modified is '%s'", url, source_timestamp)

        local = os.path.join(self.config['output'], filename)
        try:
            stat = os.stat(local)
        except OSError:
            logger.info("File %s don't already exist, download.", filename)
            save(local, url, source_timestamp,
                 self.config['owner'], self.config['group'])
        else:
            local_timestamp = datetime.datetime.fromtimestamp(
                stat.st_mtime)
            if local_timestamp < source_timestamp:
                delta = source_timestamp - local_timestamp
                logger.info("Local file %s is outdated %d seconds, download",
                            local, delta.total_seconds())
                save(local, url, source_timestamp,
                     self.config['owner'], self.config['group'])
            elif local_timestamp > source_timestamp:
                logger.info("URL '%s' timestamp is '%s' and local '%s' "
                            "timestamp is '%s': mirror is outdated, skip.",
                            url, source_timestamp, local, local_timestamp)
            else:
                logger.info("Local and remote file have same timestamp")
                try:
                    remote_size = int(req.headers[http_header_size])
                except KeyError:
                    logger.info("URL %s didn't returned a %s header, skip"
                                "size validation.", url, http_header_size)
                else:
                    if stat.st_size == remote_size:
                        logger.info("Local and remote file have same size %d, "
                                    "everything ok", remote_size)
                    else:
                        logger.warning("%s size is %d while %s size is %d, "
                                       "even if both have same last modified,"
                                       " download again", local,
                                       stat.st_size, url, remote_size)
                        save(local, url,
                             source_timestamp,
                             self.config['owner'], self.config['group'])

    def main(self):
        for prefix in self.config['files']:
            self.mirror_file(prefix + '.cvd')
        try:
            spr.call('/usr/local/bin/salt_archive_set_owner_mode.sh')
        except Exception as e:
            logger.error(e)


if __name__ == "__main__":
    ClamavMirror().run()
