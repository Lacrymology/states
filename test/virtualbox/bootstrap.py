#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
Same command line as bootstrap_archive.py

instead of create a .tar.gz file it copy files to /root/salt
"""

import os
import shutil
import sys


def insert_common_path():
    script_path = os.path.abspath(__file__)
    virtualbox_dir = os.path.dirname(script_path)
    salt_common_root = os.path.abspath(
        os.path.join(virtualbox_dir, '..', '..')
    )
    # add root of salt common to the sys.path
    sys.path.insert(0, salt_common_root)


def main():
    insert_common_path()
    import bootstrap_archive as ba
    args = ba.parse_args()
    os.chdir('/')
    try:
        shutil.rmtree('/root/salt')
    except OSError:
        pass
    for src, dst in ba.files_iter(args[0], args[1]):
        try:
            os.makedirs(os.path.dirname(dst))
        except OSError:
            pass
        sys.stdout.write(dst)
        sys.stdout.write(os.linesep)
        shutil.copy2(src, dst)

if __name__ == '__main__':
    main()
