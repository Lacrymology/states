#!/bin/bash
# {{ salt['pillar.get']('message_do_not_modify') }}
# Use of this source code is governed by a BSD license that can be
# found in the doc/license.rst file.
#
# Author: Viet Hung Nguyen <hvn@robotinfra.com>
# Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>
set -e
set -x
sudo salt-cloud --destroy --assume-yes integration-$JOB_NAME-$BUILD_NUMBER
