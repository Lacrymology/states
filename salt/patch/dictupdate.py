# -*- coding: utf-8 -*-
'''
Alex Martelli's soulution for recursive dict update from
http://stackoverflow.com/a/3233356
'''

# Import python libs
import collections


def update(dest, upd, recursive_update=True):
    '''
    Recursive version of the default dict.update

    Merges upd recursively into dest

    If recursive_update=False, will use the classic dict.update, or fall back
    on a manual merge (helpful for non-dict types like FunctionWrapper)
    '''
    if (not isinstance(dest, collections.Mapping)) \
            or (not isinstance(upd, collections.Mapping)):
        raise TypeError('Cannot update using non-dict types in dictupdate.update()')
    updkeys = list(upd.keys())
    if not set(list(dest.keys())) & set(updkeys):
        recursive_update = False
    if recursive_update:
        for key in updkeys:
            val = upd[key]
            try:
                dest_subkey = dest.get(key, None)
            except AttributeError:
                dest_subkey = None
            if isinstance(dest_subkey, collections.Mapping) \
                    and isinstance(val, collections.Mapping):
                ret = update(dest_subkey, val)
                dest[key] = ret
            elif isinstance(dest_subkey, list) \
                     and isinstance(val, list):
                dest[key] = dest.get(key, []) + val
            else:
                dest[key] = upd[key]
        return dest
    else:
        try:
            dest.update(upd)
        except AttributeError:
            # this mapping is not a dict
            for k in upd:
                dest[k] = upd[k]
        return dest


def merge(d1, d2):
    md = {}
    for k, v in d1.iteritems():
        if k in d2:
            md[k] = [v, d2[k]]
        else:
            md[k] = v
    return md
