#!/usr/bin/env python
# -*- coding: utf-8 -*-

__author__ = 'Bruno Clermont'
__maintainer__ = 'Bruno Clermont'
__email__ = 'patate@fastmail.cn'

import logging
import os
import shutil
import tarfile
import tempfile

import pysc

logger = logging.getLogger(__name__)


def recompress(archive, extension, extra_subdir=('.hg', '.git')):
    """
    Recompress archive to remove the "./" out of the filename
    :param archive:
    :return:
    """
    tmp_dir = tempfile.mkdtemp()

    # extra tar in temp directory
    tar_in = tarfile.open(archive, mode="r:%s" % extension)
    tar_in.extractall(tmp_dir)
    tar_in.close()

    # recreate archive
    tar_out = tarfile.open(archive, mode="w:%s" % extension, compresslevel=9)
    for root_item in os.listdir(tmp_dir):
        absolute_filename = os.path.join(tmp_dir, root_item)
        # remove .git and .hg
        for extra in extra_subdir:
            try:
                extra_absolute = os.path.join(absolute_filename, extra)
                shutil.rmtree(extra_absolute)
                logger.info("Cleaned up %s before archive in %s",
                            extra_absolute, absolute_filename)
            except OSError:
                pass
        tar_out.add(absolute_filename, root_item)

    # cleanup
    shutil.rmtree(tmp_dir)


def validate(dirname):
    """
    Loop into a directory check for pip tar archive and look if they're valid.
    if not fix them.
    :param dirname:
    :return:
    """
    tar_extensions = ('bz2', 'gz')
    for filename in os.listdir(dirname):
        prefix, ext = os.path.splitext(filename)
        absolute_filename = os.path.join(dirname, filename)
        extension = ext.lstrip(os.extsep)
        if extension in tar_extensions:
            logger.debug("Found tar %s", absolute_filename)
            tar_fh = tarfile.open(absolute_filename, mode='r:%s' % extension)
            # check for archive content that starts with ./
            is_invalid = False
            for member in tar_fh.getnames():
                if member.startswith('./'):
                    logger.debug("Invalid filename %s for pip archive", member)
                    is_invalid = True
                if member.endswith('/.git'):
                    logger.debug("Git repository check, cleanup %s", member)
                    is_invalid = True
                if member.endswith('/.hg'):
                    logger.debug("Mercurial repository check, cleanup %s",
                                 member)
                    is_invalid = True
            tar_fh.close()
            if is_invalid:
                logger.debug("Found invalid archive %s, recompress...",
                             absolute_filename)
                recompress(absolute_filename, extension)
            else:
                logger.debug("Valid archive %s, ignore.", absolute_filename)
        else:
            logger.debug("Ignore non tar %s", absolute_filename)

# TODO: use pysc.Util
@pysc.profile(log=logger)
def main():
    validate('/var/lib/salt_archive/pip')

if __name__ == '__main__':
    main()
