#!/usr/bin/env python2
# coding: utf-8

import os


def get_absent_states(common_path='..'):
    '''Return list of all absent states inside `common_path` directory.'''
    all_files = []
    for root, dirs, files in os.walk(common_path):
        li = [os.path.join(root, f) for f in files if '.git' not in root]
        all_files.extend([path for path in li if "absent" in path])

    return sorted([f.replace('/', '.').rstrip('.sls').lstrip('.')
                  for f in all_files])


if __name__ == "__main__":
    for i in get_absent_states():
        print i
