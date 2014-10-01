# -*- coding: utf-8 -*-

import logging

logger = logging.getLogger(__name__)


def update():
    '''
    Run a salt function specified in pillar data.
    Pass specified kwargs to it.

    This intead to be used to run arbitrary salt module and any kwargs to work
    around a limitation of salt regarding the scheduler.

    example of pillar data:
        monitoring:
          update:
            - salutil.refresh_pillar
            - state.sls:
                mods: whatever
                test: True

    or:

        monitoring:
           update:
             - state.highstate
    '''
    pillar = __salt__['pillar.get']('monitoring:update', [])
    if not pillar:
        logger.warn("Not pillar key defined, do nothing.")
    else:
        for mod in pillar:
            if isinstance(mod, basestring):
                logger.debug("output of %s: %s", mod, str(__salt__[mod]()))
            elif isinstance(mod, dict):
                func_name = mod.keys()[0]
                logger.debug("output of %s: %s", str(mod),
                             __salt__[func_name](**mod[func_name]))
            else:
                logger.error("Invalid update value %s", str(mod))


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
                # append the roles/*$rolename*(/other_optional_dir)
                role = role_dir.split('/')[1]
                if role not in output:
                    output.append(role)
    return output
