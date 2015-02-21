#!/usr/bin/env python
# -*- coding: utf-8 -*-
# {{ salt['pillar.get']('message_do_not_modify') }}
# Use of this is governed by a license that can be found in doc/license.rst.

"""
This script import test data output uploaded by cp.push to jenkins workspace.
"""

import os
import pwd

import pysc


class ImportTestData(pysc.Application):
    def get_argument_parser(self):
        argp = super(ImportTestData, self).get_argument_parser()
        argp.add_argument("file")
        argp.add_argument("minion_id")
        argp.add_argument("workspace")
        return argp

    def main(self):
        basename = self.config['file']
        source_dir = self.config['minion_id']
        workspace = self.config['workspace']
        self.move_logs(basename, source_dir, workspace)

    def move_file(self, basename, source_dir, workspace, user):
        source_filename = os.path.join(source_dir, basename)
        if not os.path.exists(source_filename):
            raise OSError("Can't find %s file %s" % (basename,
                                                     source_filename))

        destination_filename = os.path.join(workspace, basename)
        os.rename(source_filename, destination_filename)
        os.chown(destination_filename, user.pw_uid, user.pw_gid)

    def move_logs(self, basename, minion_id, workspace,
                  username='jenkins', remote_dir='/root/salt',
                  minions_dir='/var/cache/salt/master/minions'):
        try:
            user = pwd.getpwnam(username)
        except KeyError:
            raise OSError('missing user %s' % username)

        if not os.path.exists(minions_dir):
            raise OSError("Can't find salt master cache minions directory %s"
                          % minions_dir)
        if not os.path.exists(workspace):
            raise OSError("Can't find workspace directory %s" % workspace)

        minion_dir = os.path.join(minions_dir, minion_id)
        if not os.path.exists(minion_dir):
            raise OSError(
                "minion %s didn't push a file yet, can't find %s" % (
                    minion_id, minion_dir))

        source_dir = os.path.join(minion_dir, 'files') + remote_dir
        if not os.path.exists(source_dir):
            raise OSError(
                "minion %s didn't push log files yet, can't find %s" % (
                    minion_id, source_dir))

        self.move_file(basename, source_dir, workspace, user)


if __name__ == '__main__':
    ImportTestData().run()
