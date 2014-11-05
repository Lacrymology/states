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
# Author: Viet Hung Nguyen <hvn@robotinfra.com>
# Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>
#             Bruno Clermont <bruno@robotinfra.com>
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

# allow multiple --repo options to get all non-common repositories
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

BUILD_IDENTITY="integration-$JOB_NAME-$BUILD_NUMBER"
# create archive from common, pillar, and all user-specific formulas repos
./bootstrap_archive.py ../pillar ${repos[@]} > /srv/salt/jenkins_archives/$BUILD_IDENTITY.tar.gz

sudo salt-cloud --profile $profile $BUILD_IDENTITY
sudo salt $BUILD_IDENTITY test.ping | grep True
sudo salt -t 10 "$BUILD_IDENTITY" cmd.run "hostname $BUILD_IDENTITY"
sudo salt -t 60 "$BUILD_IDENTITY" cp.get_file salt://jenkins_archives/$BUILD_IDENTITY.tar.gz /tmp/bootstrap-archive.tar.gz
sudo salt -t 60 "$BUILD_IDENTITY" archive.tar xzf /tmp/bootstrap-archive.tar.gz cwd=/

PREPARE_STDOUT_LOG=/root/salt/stdout.prepare
PREPARE_STDERR_LOG=/root/salt/stderr.prepare
CUSTOM_CONFIG_DIR=/root/salt/states/test

function run_and_check_return_code {
    sudo salt -t $1 "$BUILD_IDENTITY" --output json cmd.run_all "$2" | ./test/jenkins/retcode_check.py
}

master_ip=$(sudo salt -t 60 "$BUILD_IDENTITY" --out=yaml grains.item master | cut -f2- -d ':' | tr -d '\n')
run_and_check_return_code 10 "sed -i \"s/master:.*/master: $master_ip/g\" $CUSTOM_CONFIG_DIR/minion"
# sync extmod from extracted archive to bootstrapped salt instance
run_and_check_return_code 60 "salt-call -c $CUSTOM_CONFIG_DIR saltutil.sync_all >> $PREPARE_STDOUT_LOG 2>> $PREPARE_STDERR_LOG"
run_and_check_return_code 600 "salt-call -c $CUSTOM_CONFIG_DIR state.sls test.sync >> $PREPARE_STDOUT_LOG 2>> $PREPARE_STDERR_LOG"
run_and_check_return_code 600 "salt-call -c $CUSTOM_CONFIG_DIR state.sls test.jenkins >> $PREPARE_STDOUT_LOG 2>> $PREPARE_STDERR_LOG"
echo '------------ From here, salt with version supported by salt-common is running ------------'
sudo salt -t 5 "$BUILD_IDENTITY" --output json cmd.run_all "salt-call test.ping"
run_and_check_return_code 10 "salt-call -c $CUSTOM_CONFIG_DIR state.sls salt.patch_salt >> $PREPARE_STDOUT_LOG 2>> $PREPARE_STDERR_LOG"
run_and_check_return_code 20 "salt-call -c $CUSTOM_CONFIG_DIR saltutil.sync_all >> $PREPARE_STDOUT_LOG 2>> $PREPARE_STDERR_LOG"
run_and_check_return_code 10 "salt-call -c $CUSTOM_CONFIG_DIR saltutil.refresh_modules >> $PREPARE_STDOUT_LOG 2>> $PREPARE_STDERR_LOG"

start_run_test_time=$(date +%s)
echo "TIME-METER: Preparing for test took: $((start_run_test_time - start_time)) seconds"
echo '------------ Running CI test  ------------'
sudo salt -t 86400 "$BUILD_IDENTITY" cmd.run "$CUSTOM_CONFIG_DIR/jenkins/run.py $*"
finish_run_test_time=$(date +%s)
echo "TIME-METER: Run integration.py took: $((finish_run_test_time - start_run_test_time)) seconds"

for ltype in stdout stderr; do
    run_and_check_return_code 30 "salt-call -c $CUSTOM_CONFIG_DIR cmd.run \"xz -c /root/salt/$ltype.prepare > /tmp/$BUILD_IDENTITY-$ltype.prepare.log.xz\""
    run_and_check_return_code 30 "salt-call -c $CUSTOM_CONFIG_DIR cmd.run \"xz -c /root/salt/$ltype.log > /tmp/$BUILD_IDENTITY-$ltype.log.xz\""
done

sudo salt -t 60 "$BUILD_IDENTITY" --output json cmd.run_all "salt-call -l info -c $CUSTOM_CONFIG_DIR state.sls test.jenkins.result"

xz -d -c /home/ci-agent/$BUILD_IDENTITY-stderr.log.xz
cp /home/ci-agent/$BUILD_IDENTITY-result.xml $WORKSPACE/result.xml
for f in /home/ci-agent/$BUILD_IDENTITY-*.log.xz; do
  cp $f $WORKSPACE/`basename $f | sed "s/$BUILD_IDENTITY/$JOB_NAME/"`
done
mv /srv/salt/jenkins_archives/$BUILD_IDENTITY.tar.gz $WORKSPACE/bootstrap-archive.tar.gz
echo "TIME-METER: Total time: $(($(date +%s) - start_time)) seconds"
