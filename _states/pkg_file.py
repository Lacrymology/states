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
Package file states.
"""

__author__ = 'Bruno Clermont'
__maintainer__ = 'Bruno Clermont'
__email__ = 'bruno@robotinfra.com'

import logging
import os

log = logging.getLogger(__name__)


def installed(name, version, source, source_hash):
    ret = {'name': name, 'result': None, 'changes': {}, 'comment': ''}
    if __salt__['pkg.version'](name) == version:
        ret['result'] = True
        ret['comment'] = '{0} is already at version {1}'.format(name, version)
    else:
        filename = os.path.join('/var/cache/apt/archives',
                                'pkg_file-{0}-{1}'.format(name, version))
        if not os.path.exists(filename):
            if __opts__['test']:
                ret['result'] = None
                ret['comment'] = \
                    'Package {0} would have been downloaded'.format(source)
                return ret
            log.debug("Package file for %s(%s) is not in cache, download it",
                      name, version)
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
            file_result = __salt__['state.high'](data).values()[0]
            log.debug("file.managed: %s", file_result)

            try:
                if not file_result['result']:
                    return file_result
            except KeyError:
                return file_result
        else:
            log.debug("Package file for %s(%s) is already in cache", name,
                      version)

        if __opts__['test']:
            ret['result'] = None
            ret['comment'] = \
                'Package file {0} would have been installed'.format(filename)
            return ret

        os.environ.update({
            'APT_LISTBUGS_FRONTEND': 'none',
            'APT_LISTCHANGES_FRONTEND': 'none',
            'DEBIAN_FRONTEND': 'noninteractive',
        })
        __salt__['cmd.run']('dpkg --install --force-confnew {0}'.format(
            filename))
        if __salt__['pkg.version'](name) == version:
            ret['result'] = True
            ret['comment'] = '{0} version {1} is installed'.format(name,
                                                                   version)
            ret['changes']['pkg'] = {'installed': '{0} version {1}'.format(
                name, version)}
            os.unlink(filename)
        else:
            ret['result'] = False
            ret['comment'] = "Can't install {0} version {1}".format(name,
                                                                     version)
    return ret
