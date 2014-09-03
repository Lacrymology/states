#!/usr/bin/env python2
# -*- coding: utf-8 -*-

'''
A cron script for find and delete all workspaces which have no
corresponding jobs
'''

# Copyright (c) 2014, Hung Nguyen Viet All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice,
# this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright notice,
# this list of conditions and the following disclaimer in the documentation
# and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
# BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
# OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
# IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

__author__ = 'Hung Nguyen Viet <hvnsweeting@gmail.com>'
__maintainer__ = 'Hung Nguyen Viet <hvnsweeting@gmail.com>'
__email__ = 'hvnsweeting@gmail.com'

import os
import shutil
import sys

WS = '/var/lib/jenkins/workspace/'
JOBS_DIR = '/var/lib/jenkins/jobs/'

# No workspace has created yet. This is likely a new installed Jenkins
if not os.path.isdir(WS):
    sys.exit(0)

workspaces = os.listdir(WS)
ws_without_jobs = []
for ws in workspaces:
    job_is_existing = False
    for jdir in os.listdir(JOBS_DIR):
        if ws.startswith(jdir):
            job_is_existing = True
            break
    if not job_is_existing:
        shutil.rmtree(os.path.join(WS, ws))
