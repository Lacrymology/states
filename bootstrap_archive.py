#!/usr/bin/env python2
# -*- coding: utf-8 -*-

# Use of this is governed by a license that can be found in doc/license.rst.

"""
Salt master or test bootstrap creator.

To use it you need checkout the following 3 (or more) repositories into your
own workstation:

- Common (where this file is)
- Client specific repositories (where the roles and client formulas are)
- Pillar repository

To use it run this script::

  cd ~/somewhere/common-checkout/
  ./boostrap_archive.py /path/to/pillars ~/somewhere/client-checkout > /path/to/archive.tar.gz

Note: - first argument is always the pillar path
      - multiple client specific repositories can be passed as arguments.
"""

__author__ = 'Bruno Clermont'
__maintainer__ = 'Bruno Clermont'
__email__ = 'bruno@robotinfra.com'

import os
import sys
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


def files_dir_iter(dir_name):
    """
    iter trough a directory and list all files that aren't in a .git
    directory
    """
    l_dir_name = len(dir_name) + 1
    for (path, dirs, files) in os.walk(dir_name):
        if not path.endswith('/.git') and '/.git/' not in path:
            for filename in files:
                if not filename.endswith('.pyc'):
                    yield os.path.abspath(
                        os.path.join(path, filename))[l_dir_name:]


def unique_states(states_dir, root_states='root/salt/states'):
    """
    Return unique states files and their relative path in /root/salt/states.
    If a single file is multiple repository, only the last one is considered.
    """
    output = {}
    for dirname in states_dir:
        for filename in files_dir_iter(dirname):
            output[filename] = os.path.join(dirname, filename)

    # top.sls is copy of salt/master/top.jinja2 but not rendered
    output['top.sls'] = output['salt/master/top.jinja2']

    clean_root_states = root_states.rstrip(os.sep)
    filenames = output.keys()
    filenames.sort()
    for filename in filenames:
        yield (os.path.join(clean_root_states, filename),
               output[filename])


def files_iter(pillar_root, extra_states_dir=None):
    """
    List all files in pillar and states required to run tests
    :param pillar_root: directory that hold pillars
    :param extra_states_dir: list of states directory
    :return: iterator that yield tuple of files to archive.
    """
    # pillar
    for filename in files_dir_iter(pillar_root):
        yield (os.path.join(pillar_root, filename),
               'root/salt/pillar/' + filename)

    # guess the common repository from the path to reach this file
    common_root = os.path.dirname(os.path.abspath(__file__))
    # states
    all_states = [common_root]
    if extra_states_dir:
        all_states.extend(extra_states_dir)

    for source, destination in unique_states(all_states):
        yield destination, source


def create_archive(pillar_root, states_root, fileobj=sys.stdout,
                   compression=True):
    if compression:
        mode = 'w:gz'
    else:
        mode = 'w:'
    tar = tarfile.open(mode=mode, fileobj=fileobj)
    for source, destination in files_iter(pillar_root, states_root):
        tar.add(source, destination)
    tar.close()


def parse_args():
    if len(sys.argv) >= 3:
        states = []
        for dirname in sys.argv[2:]:
            states.append(validate_git_dir(dirname))
        return validate_git_dir(sys.argv[1]), states
    elif len(sys.argv) == 2:
        return validate_git_dir(sys.argv[1]), None
    else:
        print ('%s <path to pillar> [repo1_dir] [repo2_dir] ...'
               % sys.argv[0])
        sys.exit(1)


def main():
    create_archive(*parse_args())

if __name__ == '__main__':
    main()
