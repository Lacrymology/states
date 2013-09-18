# -*- coding: utf-8 -*-
__author__ = 'Bruno Clermont'
__maintainer__ = 'Bruno Clermont'
__email__ = 'patate@fastmail.cn'
import salt.modules.cmdmod


def arch():
    return {
        'debian_arch': salt.modules.cmdmod._run_quiet(
            'dpkg --print-architecture')
    }
