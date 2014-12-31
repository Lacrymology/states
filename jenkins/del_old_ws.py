#!/usr/bin/env python2
# -*- coding: utf-8 -*-

'''
A cron script for find and delete all workspaces which have no
corresponding jobs
'''

# Use of this source code is governed by a BSD license that can be
# found in the doc/license.rst file.

__author__ = 'Viet Hung Nguyen <hvn@robotinfra.com>'
__maintainer__ = 'Viet Hung Nguyen <hvn@robotinfra.com>'
__email__ = 'hvn@robotinfra.com'


import os
import shutil
import sys

import pysc


class DelOldWs(pysc.Application):
    defaults = {
        'workspace': '/var/lib/jenkins/workspace/',
        'jobs_dir': '/var/lib/jenkins/jobs/',
    }

    def main(self):
        # No workspace has created yet. This is likely a new installed Jenkins
        if not os.path.isdir(self.config['workspace']):
            sys.exit(0)

        workspaces = os.listdir(self.config['workspace'])
        for ws in workspaces:
            job_is_existing = False
            for jdir in os.listdir(self.config['jobs_dir']):
                if ws.startswith(jdir):
                    job_is_existing = True
                    break
            if not job_is_existing:
                shutil.rmtree(os.path.join(self.config['workspace'], ws))


if __name__ == '__main__':
    DelOldWs().run()
