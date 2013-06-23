#!/usr/bin/env python
# -*- coding: utf-8 -*-

'''
Fake the mine module, this let a minion to run without a master.
'''

def __virtual__():
    return 'mine'

def get(*args):
    minion_id = __salt__['grains.item']('id')['id']
    return {minion_id: __salt__['monitoring.data']()}
