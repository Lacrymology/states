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
# NOTICE: this script executed as jenkins user

set -x
start_time=$(date +%s)
rm -f $WORKSPACE/bootstrap-archive.tar.gz $WORKSPACE/stderr.log.xz $WORKSPACE/stdout.log.xz $WORKSPACE/result.xml
rm -rf $WORKSPACE/salt-common-doc
virtualenv $WORKSPACE/virtualenv
. $WORKSPACE/virtualenv/bin/activate

if [ "${with_ssl:-true}" = "false" ]; then
  $WORKSPACE/common/test/jenkins/generate_non_ssl_pillar.sh pillar
fi

cd common
test/lint.py --tabonly
pip install -r doc/requirements.txt
doc/build.py

if [ "$1" == "--profile" ]; then
    profile=$2
    shift
    shift
else
    profile='ci-minion'
fi

# allow multiple --repo options to get all non-common reporitories
# each value passed to  --repo is relative path to user-specific directory from
# $WORKSPACE. The structure after all SCM checkout looks like:
#  - common
#  - pillar
#  - repo1
#  - repo2
# then use --repo repo1 --repo repo2
# NOTICE --repo must come after --profile if --profile is used.
repos=()
cntr=0
while [ "${1}" = '--repo' ]; do
    repos[${cntr}]="../${2}"
    cntr+=1
    shift
    shift
done

# create archive from common, pillar, and all user-specific formulas repos
./bootstrap_archive.py ../pillar ${repos[@]} > /srv/salt/jenkins_archives/$JOB_NAME-$BUILD_NUMBER.tar.gz

sudo salt-cloud --profile $profile integration-$JOB_NAME-$BUILD_NUMBER
sudo salt integration-$JOB_NAME-$BUILD_NUMBER test.ping | grep True
sudo salt -t 10 "integration-$JOB_NAME-$BUILD_NUMBER" cmd.run "hostname integration-$JOB_NAME-$BUILD_NUMBER"
sudo salt -t 60 "integration-$JOB_NAME-$BUILD_NUMBER" cp.get_file salt://jenkins_archives/$JOB_NAME-$BUILD_NUMBER.tar.gz /tmp/bootstrap-archive.tar.gz
sudo salt -t 60 "integration-$JOB_NAME-$BUILD_NUMBER" archive.tar xzf /tmp/bootstrap-archive.tar.gz cwd=/
master_ip=$(sudo salt -t 60 "integration-$JOB_NAME-$BUILD_NUMBER" --out=yaml grains.item master | cut -f2- -d ':' | tr -d '\n')
sudo salt -t 10 "integration-$JOB_NAME-$BUILD_NUMBER" --output json cmd.run_all "sed -i \"s/master:.*/master: $master_ip/g\" /root/salt/states/test/minion" | ./test/jenkins/retcode_check.py
# sync extmod from extracted archive to bootstrapped salt instance
sudo salt -t 60 "integration-$JOB_NAME-$BUILD_NUMBER" --output json cmd.run_all "salt-call -c /root/salt/states/test/ saltutil.sync_all >> /root/salt/stdout.log 2>> /root/salt/stderr.log"
sudo salt -t 600 "integration-$JOB_NAME-$BUILD_NUMBER" --output json cmd.run_all "salt-call -c /root/salt/states/test/ state.sls test.sync >> /root/salt/stdout.log 2>> /root/salt/stderr.log"
sudo salt -t 600 "integration-$JOB_NAME-$BUILD_NUMBER" --output json cmd.run_all "salt-call -c /root/salt/states/test/ state.sls test.jenkins >> /root/salt/stdout.log 2>> /root/salt/stderr.log"
echo '------------ From here, salt with version supported by salt-common is running ------------'
sudo salt -t 10 "integration-$JOB_NAME-$BUILD_NUMBER" --output json cmd.run_all "salt-call -c /root/salt/states/test/ state.sls test.jenkins.patch_salt" | ./test/jenkins/retcode_check.py
sudo salt -t 5 "integration-$JOB_NAME-$BUILD_NUMBER" --output json cmd.run_all "salt-call test.ping"
sudo salt -t 20 "integration-$JOB_NAME-$BUILD_NUMBER" --output json cmd.run_all "salt-call -c /root/salt/states/test/ saltutil.sync_all >> /root/salt/stdout.log 2>> /root/salt/stderr.log"
sudo salt -t 10 "integration-$JOB_NAME-$BUILD_NUMBER" --output json cmd.run_all "salt-call -c /root/salt/states/test/ saltutil.refresh_modules >> /root/salt/stdout.log 2>> /root/salt/stderr.log"
start_run_test_time=$(date +%s)
echo "TIME-METER: Preparing for test took: $((start_run_test_time - start_time)) seconds"
echo '------------ Running CI test  ------------'
sudo salt -t 86400 "integration-$JOB_NAME-$BUILD_NUMBER" cmd.run "/root/salt/states/test/jenkins/run.py $*"
finish_run_test_time=$(date +%s)
echo "TIME-METER: Run integration.py took: $((finish_run_test_time - start_run_test_time)) seconds"
sudo salt -t 60 "integration-$JOB_NAME-$BUILD_NUMBER" --output json cmd.run_all "salt-call -c /root/salt/states/test/ state.sls test.jenkins.result >> /root/salt/stdout.log 2>> /root/salt/stderr.log"
cp /home/ci-agent/integration-$JOB_NAME-$BUILD_NUMBER-stderr.log.xz $WORKSPACE/stderr.log.xz
xz -d -c $WORKSPACE/stderr.log.xz
cp /home/ci-agent/integration-$JOB_NAME-$BUILD_NUMBER-stdout.log.xz $WORKSPACE/stdout.log.xz
cp /home/ci-agent/integration-$JOB_NAME-$BUILD_NUMBER-result.xml $WORKSPACE/result.xml
mv /srv/salt/jenkins_archives/$JOB_NAME-$BUILD_NUMBER.tar.gz $WORKSPACE/bootstrap-archive.tar.gz
echo "TIME-METER: Total time: $(($(date +%s) - start_time)) seconds"
