#!/usr/bin/env python2
# coding: utf-8

import os


def get_absent_states(common_path='..'):
    '''Return list of all states inside `common_path` directory.'''
    all_files = []
    for root, _, files in os.walk(common_path):
        li = [os.path.join(root, f) for f in files]
        all_files.extend([path for path in li if '.sls' in path])

    # format output to saltstack DSL
    all_files = [f.replace('/', '.')[:f.rfind('.sls')].lstrip('.')
                 for f in all_files
                 if not f.startswith('.git') and not f.startswith('doc.')]

    return sorted(all_files)


if __name__ == "__main__":
    print 'all:', 10 * '*'
    for i in get_absent_states():
        print i
