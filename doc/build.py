#!/usr/bin/env python
# Copyright (c) 2014, Hung Nguyen Viet
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
#
# Author: Viet Hung Nguyen <hvn@robotinfra.com>
# Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>
#
# Script for building salt common documentation.

import os
import sys

def in_directory(dir1, dir2):
    dirs1 = dir1.split(os.sep)
    dirs2 = dir2.split(os.sep)

    for i in range(0, len(dirs1)):
        try:
            if dirs1[i] != dirs2[i]:
                return False
        except IndexError:
            return False
    return True

def common_root_dir():
    my_dir = os.path.dirname(os.path.abspath(__file__))
    return os.path.abspath(os.path.join(my_dir, '..'))

def main():
    root_dir = common_root_dir()
    default_directory = os.path.abspath(os.path.join(root_dir, '..',
                                                     'salt-doc'))

    if len(sys.argv) > 2:
        print "Invalid argument."
        print "%s [output-directory]"
        print "Default directory: %s" % default_directory
        sys.exit(1)

    # check if it's a valid virtualenv path
    virtualenv_key = 'VIRTUAL_ENV'
    if virtualenv_key not in os.environ:
        print "Please use a Python VirtualEnv"
        sys.exit(1)
    virtual_env = os.path.abspath(os.environ[virtualenv_key])

    if in_directory(virtual_env, root_dir):
        print "Please don't use Python VirtualEnv %s inside %s" % (virtual_env,
                                                                   root_dir)
        sys.exit(1)

    # replace argv to pass to sphinx-build
    try:
        output_dir = sys.argv[1]
        if output_dir.startswith(root_dir):
            print "Please specify an output directory outside %s" % root_dir
            sys.exit(1)
    except IndexError:
        output_dir = default_directory
        print 'Output directory is %s' % default_directory

    os.chdir(root_dir)
    sys.argv[1:] = ['-c', 'doc', '-W', '.', output_dir]

    from pkg_resources import load_entry_point
    sys.exit(
        load_entry_point('Sphinx', 'console_scripts', 'sphinx-build')()
    )

if __name__ == '__main__':
    main()
