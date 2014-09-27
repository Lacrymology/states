# -*- coding: utf-8 -*-

import logging

logger = logging.getLogger(__name__)


def saltenv():
    '''
    Salt Common default saltenv (ie. not specified trough env= kwarg).
    '''

    if __opts__['file_client'] == 'local':
        logger.info("local mode don't support gitfs and multiple branches, "
                    "force to use 'base' environment")
        return 'base'

    logger.debug("file_client not in local mode.")
    output = __salt__['pillar.get']('branch', 'base')
    if output == 'master':
        return 'base'
    return output


def global_roles():
    '''
    Salt Common list of all available roles.
    '''
    output = __salt__['pillar.get']('global_roles', [])
    if output in ('', []):
        output = []

        for role_dir in __salt__['cp.list_master_dirs'](saltenv(), 'roles'):
            # cp.list_master_dirs return 'roles' which is root dir, ignore.
            # only consider sub-directories
            if '/' in role_dir:
                # append the roles/*$rolename*
                output.append(role_dir.split('/')[1])
    return output
