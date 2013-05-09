#!/usr/bin/env python

"""
Salt master bootstrap creator.

To use it you need checkout the following 3 repositories into your own
workstation:

- Common (where this file is)
- Client specific (where the roles are)
- Pillar repository

To use it run this script::

  cd ~/somewhere/common-checkout/salt/master
  ./boostrap_archive.py /path/to/pillars ~/somewhere/client-checkout > /path/to/archive.tar.gz

Note: first argument is always the pillar path

Take /path/to/archive.tar.gz and copy it to remote salt master.

Then on the server run::

  cd /
  tar -xvzf /whereis/copied/archive.tar.gz
  sh /tmp/bootstrap_master.sh

"""

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

def main():
    """
    main loop.
    :return: None
    """
    if len(sys.argv) != 3:
        print '%s: [path to pillar] [path to states]' % sys.argv[0]
        sys.exit(1)
    # guess the common repository from the path to reach this file
    common_root = os.sep.join(os.path.abspath(__file__).split(os.sep)[:-3])
    pillar_root = validate_git_dir(sys.argv[1])
    states_root = validate_git_dir(sys.argv[2])

    tar = tarfile.open(mode='w:gz', fileobj=sys.stdout)

    # pillar
    for filename in os.listdir(pillar_root):
        tar.add(os.path.join(pillar_root, filename),
                'srv/pillar/' + filename)

    # states
    for state_dir in (common_root, states_root):
        for filename in os.listdir(state_dir):
            if filename != '.git':
                tar.add(os.path.join(state_dir, filename),
                        'srv/salt/' + filename)

    tar.add(os.path.join(common_root, 'salt', 'master', 'top.jinja2'),
            'srv/salt/top.sls')

    # bootstrap script
    tar.add(os.path.join(common_root, 'salt', 'master', 'bootstrap_master.sh'),
            'tmp/bootstrap_master.sh')
    tar.close()

if __name__ == '__main__':
    main()
