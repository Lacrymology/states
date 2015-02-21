#!/bin/bash
# {{ salt['pillar.get']('message_do_not_modify') }}
# Usage of this is governed by a license that can be found in doc/license.rst

# script to removes all SSL relate stuff from files locate into input dir
# this will change the origin pillar files, make it become non-SSL pillar,
# which used to test formulas with non-SSL.
pillar_dir=$1
find $pillar_dir -name '*.sls' -type f -exec sed -i -e 's/  ssl_redirect:.*//g' -e 's/  ssl:.*//g' {} \;
# show changes for debugging purpose
cd $pillar_dir
git diff
