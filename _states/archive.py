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
Archive states.
"""

__author__ = 'Bruno Clermont'
__maintainer__ = 'Bruno Clermont'
__email__ = 'patate@fastmail.cn'

import logging
import os

log = logging.getLogger(__name__)

def extracted(name, source, archive_format, tar_options=None, source_hash=None,
              if_missing=None):
    '''
    State that make sure an archive is extracted in a directory.
    The downloaded archive is erased if succesfully extracted.
    The archive is downloaded only if necessary.

    .. code-block:: yaml

    graylog2-server:
      archive:
        - extracted
        - name: /opt/
        - source: https://github.com/downloads/Graylog2/graylog2-server/graylog2-server-0.9.6p1.tar.gz
        - source_hash: md5=499ae16dcae71eeb7c3a30c75ea7a1a6
        - archive_format: tar
        - tar_options: z
        - if_missing: /opt/graylog2-server-0.9.6p1/

    name
        Directory name where to extract the archive

    source
        Archive source, same syntax as file.managed source argument.

    archive_format
        tar, zip or rar

    if_missing
        Some archive, such as tar, extract themself in a subfolder.
        This directive can be used to validate if the archive had been
        previously extracted.

    tar_options
        Only used for tar format, it need to be the tar argument specific to
        this archive, such as 'j' for bzip2, 'z' for gzip, '' for uncompressed
        tar, 'J' for LZMA.
    '''
    ret = {'name': name, 'result': None, 'changes': {}, 'comment': ''}
    valid_archives = ('tar', 'rar', 'zip')

    if archive_format not in valid_archives:
        ret['result'] = False
        ret['comment'] = '{0} is not supported, valids: {1}'.format(
            name, ','.join(valid_archives))
        return ret

    if archive_format == 'tar' and tar_options is None:
        ret['result'] = False
        ret['comment'] = 'tar archive need argument tar_options'
        return ret

    if if_missing is None:
        if_missing = name
    if (__salt__['file.directory_exists'](if_missing) or
        __salt__['file.file_exists'](if_missing)):
        ret['result'] = True
        ret['comment'] = '{0} already exists'.format(if_missing)
        return ret

    log.debug("Input seem valid so far")
    filename = os.path.join(__opts__['cachedir'],
                            '{0}.{1}'.format(if_missing.replace('/', '_'),
                                             archive_format))
    if not salt['file.file_exists'](filename):
        if __opts__['test']:
            ret['result'] = None
            ret['comment'] = \
                'Archive {0} would have been downloaded in cache'.format(source,
                                                                         name)
            return ret

        log.debug("Archive file %s is not in cache, download it", source)
        data = {
            filename: {
                'file': [
                    'managed',
                    {'name': filename},
                    {'source': source},
                    {'source_hash': source_hash},
                    {'makedirs': True}
                ]
            }
        }
        file_result = __salt__['state.high'](data)
        log.debug("file.managed: %s", file_result)
        # get value of first key
        file_result = file_result[file_result.keys()[0]]
        if not file_result['result']:
            log.debug("failed to download %s", source)
            return file_result
    else:
        log.debug("Archive file %s is already in cache", name)

    if __opts__['test']:
        ret['result'] = None
        ret['comment'] = 'Archive {0} would have been extracted in {1}'.format(
            source, name)
        return ret

    __salt__['file.makedirs'](name)

    if archive_format in ('zip', 'rar'):
        log.debug("Extract %s in %s", filename, name)
        files = __salt__['archive.un{0}'.format(archive_format)](filename, name)
    else:
        # this is needed until merging PR 2651
        log.debug("Untar %s in %s", filename, name)
        results = __salt__['cmd.run_all']('tar -xv{0}f {1}'.format(tar_options,
                                                             filename),
                                          cwd=name)
        if results['retcode'] != 0:
            return results
        files = results['stdout']
    if len(files) > 0:
        ret['result'] = True
        ret['changes']['directories_created'] = [name]
        if if_missing != name:
            ret['changes']['directories_created'].append(if_missing)
        ret['changes']['extracted_files'] = files
        ret['comment'] = "{0} extracted in {1}".format(source, name)
        __salt__['file.remove'](filename)
    else:
        __salt__['file.remove'](if_missing)
        ret['result'] = False
        ret['comment'] = "Can't extract content of {0}".format(source)
    return ret
