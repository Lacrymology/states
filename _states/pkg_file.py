# -*- coding: utf-8 -*-

# Use of this source code is governed by a BSD license that can be
# found in the doc/license.rst file.

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
