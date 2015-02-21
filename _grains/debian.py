# -*- coding: utf-8 -*-

# Usage of this is governed by a license that can be found in doc/license.rst.

__author__ = 'Bruno Clermont'
__maintainer__ = 'Bruno Clermont'
__email__ = 'bruno@robotinfra.com'

import salt.modules.cmdmod


def arch():
    return {
        'debian_arch': salt.modules.cmdmod._run_quiet(
            'dpkg --print-architecture')
    }
