#!/usr/bin/env python2
# -*- coding: utf-8 -*-

# Copyright (c) 2013, Bruno Clermont
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice, this
#    list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
# ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

"""
Salt master or test bootstrap creator.

To use it you need checkout the following 3 repositories into your own
workstation:

- Common (where this file is)
- Client specific (where the roles are)
- Pillar repository

To use it run this script::

  cd ~/somewhere/common-checkout/
  ./boostrap_archive.py /path/to/pillars ~/somewhere/client-checkout > /path/to/archive.tar.gz

Note: first argument is always the pillar path
"""

__author__ = 'Bruno Clermont'
__maintainer__ = 'Bruno Clermont'
__email__ = 'patate@fastmail.cn'

import sys
import os
import tarfile


def validate_git_dir(dirname):
    """
    validate that specified directory is a git checkout.
    :param dirname: directory path
    :type dirname: string
    :return: absolute path of directory
    :rtype: string
    """
    abs_path = os.path.abspath(dirname)
    if not os.path.exists(abs_path):
        print "Can't find %s" % abs_path
        sys.exit(1)
    git_subdir = os.path.join(abs_path, '.git')
    if not os.path.exists(git_subdir):
        print "%s is not a git checkout" % abs_path
        sys.exit(1)
    return abs_path


def add_symlink(tar, src, dst):
    tmpfile = '/tmp/{0}_{1}'.format(os.getpid(), src.replace('/', '_'))
    try:
        os.symlink(src, tmpfile)
    except OSError:
        pass
    tar.add(tmpfile, dst)
    os.remove(tmpfile)
    return


def main():
    """
    main loop.
    :return: None
    """
    if len(sys.argv) >= 3:
        states_root = (validate_git_dir(git_dir) for git_dir in sys.argv[2:])
    elif len(sys.argv) == 2:
        states_root = None
    else:
        print '%s: [path to pillar] [path to states]' % sys.argv[0]
        sys.exit(1)

    tar = tarfile.open(mode='w:gz', fileobj=sys.stdout)

    # pillar
    pillar_root = validate_git_dir(sys.argv[1])
    for filename in os.listdir(pillar_root):
        if filename != '.git':
            tar.add(os.path.join(pillar_root, filename),
                    'root/salt/pillar/' + filename)

    # guess the common repository from the path to reach this file
    common_root = os.path.dirname(os.path.abspath(__file__))
    # states
    all_states = [common_root]
    if states_root:
        all_states.extend(states_root)

    for state_dir in all_states:
        for filename in os.listdir(state_dir):
            if filename != '.git':
                tar.add(os.path.join(state_dir, filename),
                        'root/salt/states/' + filename)

    tar.add(os.path.join(common_root, 'salt', 'master', 'top.jinja2'),
            'root/salt/states/top.sls')

    tar.close()

if __name__ == '__main__':
    main()
