# -*- coding: utf-8 -*-


def architecture():
    return {
        'debian_architecture': __salt__['cmd.run']('dpkg --print-architecture')
    }
