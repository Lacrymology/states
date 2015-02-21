#!/bin/bash
# Use of this is governed by a license that can be found in doc/license.rst.

# Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>
set -e
set -x
sudo salt-cloud --destroy --assume-yes integration-$JOB_NAME-$BUILD_NUMBER
