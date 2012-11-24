# -*- coding: utf-8 -*-
# author: Bruno Clermont <patate@fastmail.cn>

'''
Package file states
===================


'''

import logging
import os

log = logging.getLogger(__name__)

def installed(name, version, source, source_hash):
    ret = {'name': name, 'result': None, 'changes': {}, 'comment': ''}
    if  __salt__['pkg.version'](name) == version:
        ret['result'] = True
        ret['comment'] = '{0} is already at version {1}'.format(name, version)
    else:
        filename = os.path.join(__opts__['cachedir'],
                                'pkg_file-{0}-{1}'.format(name, version))
        if not os.path.exists(filename):
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

        os.environ.update({
            'APT_LISTBUGS_FRONTEND': 'none',
            'APT_LISTCHANGES_FRONTEND': 'none',
            'DEBIAN_FRONTEND': 'noninteractive',
        })
        __salt__['cmd.run']('dpkg --install --force-confnew {0}'.format(
            filename))
        if  __salt__['pkg.version'](name) == version:
            ret['result'] = True
            ret['comment'] = '{0} version {1} is installed'.format(name,
                                                                   version)
            ret['changes']['pkg'] = {'installed': '{0} version {1}'.format(
                name, version)}
            os.unlink(filename)
        else:
            ret['result'] = False
            ret['comment']  = "Can't install {0} version {1}".format(name,
                                                                     version)
#        ret['changes'] = __salt__['pkg.install'](
#            name, sources=[{'cache_file': filename}])
#        log.debug("BCBC OUTPUT %s", str(ret['changes']))
#        try:
#            ret['result'] = ret['changes'][name]['new'] == version
#        except KeyError:
#            ret['result'] = False
#        log.debug("BCBC2 %s - new:'%s' version:'%s'", ret['result'], ret['changes'][name]['new'],version)
#        if ret['result']:
#            log.debug("package %s(%s) is installed, remove cache file", name,
#                      version)
#            os.unlink(filename)
    return ret
