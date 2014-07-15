#!/bin/bash
pillar_dir=$1
cd $pillar_dir
sed -i 's/  ssl_redirect:.*//g' integration.sls
sed -i 's/  ssl:.*//g' integration.sls
# show changes for debugging purpose
git diff
