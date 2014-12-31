# -*- coding: utf-8 -*-

# Use of this source code is governed by a BSD license that can be
# found in the doc/license.rst file.

__author__ = 'Bruno Clermont'
__maintainer__ = 'Bruno Clermont'
__email__ = 'bruno@robotinfra.com'

import salt.modules.cmdmod


def arch():
    return {
        'debian_arch': salt.modules.cmdmod._run_quiet(
            'dpkg --print-architecture')
    }
