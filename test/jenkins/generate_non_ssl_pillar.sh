#!/bin/bash
# script to removes all SSL relate stuff from files locate into input dir
# this will change the origin pillar files, make it become non-SSL pillar,
# which used to test formulas with non-SSL.
pillar_dir=$1
cd $pillar_dir
sed -i 's/  ssl_redirect:.*//g' *.sls
sed -i 's/  ssl:.*//g' *.sls
# show changes for debugging purpose
git diff
