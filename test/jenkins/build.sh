#!/bin/bash
# {{ pillar['message_do_not_modify'] }}
set -e

# Copyright (c) 2013, Hung Nguyen Viet
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
# Author: Hung Nguyen Viet <hvnsweeting@gmail.com>
# Maintainer: Hung Nguyen Viet <hvnsweeting@gmail.com>
#             Bruno Clermont <patate@fastmail.cn>

set -x
rm -f $WORKSPACE/bootstrap-archive.tar.gz $WORKSPACE/stderr.log.xz $WORKSPACE/stdout.log.xz $WORKSPACE/result.xml
rm -rf $WORKSPACE/salt-common-doc
virtualenv $WORKSPACE/virtualenv
. $WORKSPACE/virtualenv/bin/activate
pip install -r doc/requirements.txt
cd common
doc/build.sh
./bootstrap_archive.py ../pillar ../non-common > /srv/salt/jenkins_archives/$JOB_NAME-$BUILD_NUMBER.tar.gz
sudo salt-cloud -p ci-minion integration-$JOB_NAME-$BUILD_NUMBER
sudo salt -t 600 "integration-$JOB_NAME-$BUILD_NUMBER" cmd.run "hostname integration-$JOB_NAME-$BUILD_NUMBER"
sudo salt -t 600 "integration-$JOB_NAME-$BUILD_NUMBER" cp.get_file salt://jenkins_archives/$JOB_NAME-$BUILD_NUMBER.tar.gz /tmp/bootstrap-archive.tar.gz
sudo salt -t 600 "integration-$JOB_NAME-$BUILD_NUMBER" archive.tar xzf /tmp/bootstrap-archive.tar.gz cwd=/
sudo salt -t 600 "integration-$JOB_NAME-$BUILD_NUMBER" --output json cmd.run_all "salt-call -c /root/salt/states/test/ state.sls test.jenkins" | /usr/local/bin/retcode_check.py
sudo /usr/local/bin/wait_minion_up.py integration-$JOB_NAME-$BUILD_NUMBER
sudo salt -t {{ salt['pillar.get']('salt:ci:timeout', 86400) }} "integration-$JOB_NAME-$BUILD_NUMBER" cmd.run "/root/salt/states/test/jenkins/run.py $*"
sudo salt -t 600 "integration-$JOB_NAME-$BUILD_NUMBER" state.sls test.jenkins.result
sudo /usr/local/bin/import_test_data.py stderr.log.xz integration-$JOB_NAME-$BUILD_NUMBER $WORKSPACE
xz -d -c $WORKSPACE/stderr.log.xz
sudo /usr/local/bin/import_test_data.py stdout.log.xz integration-$JOB_NAME-$BUILD_NUMBER $WORKSPACE
sudo /usr/local/bin/import_test_data.py result.xml integration-$JOB_NAME-$BUILD_NUMBER $WORKSPACE
mv /srv/salt/jenkins_archives/$JOB_NAME-$BUILD_NUMBER.tar.gz $WORKSPACE/bootstrap-archive.tar.gz
