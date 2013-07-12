#!/usr/bin/env python2
# coding: utf-8

import os
import itertools


def get_absent_states(filters=None, common_path='..'):
    if filters is None:
        filters = ['.sls']
    '''Return list of all `expect` states inside `common_path` directory.
    `expect`, for example,  can be 'absent.sls' or 'init.sls' ...

    '''
    all_files = []
    for root, _, files in os.walk(common_path):
        li = [os.path.join(root, f) for f in files]
        all_files.extend([path for path in li
                         if all(itertools.imap(lambda x, y: x in y, filters, itertools.repeat(f)))])

    # format output to saltstack DSL
    all_files = [f.replace('/', '.')[:f.rfind('.sls')].lstrip('.')
                 for f in all_files
                 if not f.startswith('.git') and not f.startswith('doc.')]

    return sorted(all_files)


if __name__ == "__main__":
    print 'all:', 10 * '*'
    for i in get_absent_states():
        print i

    print 'absent', 10 * '*'
    for i in get_absent_states(['absent']):
        print i
