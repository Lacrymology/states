# -*- coding: utf-8 -*-

import salt.modules.cmdmod


def arch():
    return {
        'debian_arch': salt.modules.cmdmod._run_quiet(
            'dpkg --print-architecture')
    }
