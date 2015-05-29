#!/usr/bin/env python2
# -*- coding: utf-8 -*-
# Use of this is governed by a license that can be found in doc/license.rst.

'''
A cron script for find and delete all workspaces which have no
corresponding jobs
'''

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
        c = self.config
        if not os.path.isdir(c['workspace']):
            sys.exit(0)

        workspaces = [name for name in os.listdir(c['workspace'])
                      if os.path.isdir(os.path.join(c['workspace'], name))]
        for ws in workspaces:
            job_is_existing = False
            for jdir in os.listdir(c['jobs_dir']):
                if ws.startswith(jdir):
                    job_is_existing = True
                    break
            if not job_is_existing:
                shutil.rmtree(os.path.join(c['workspace'], ws))


if __name__ == '__main__':
    DelOldWs().run()
