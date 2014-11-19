#!/bin/bash

# script for use with diamond collector userscripts

count=`grep -v '^[\s]*\(#\|$\)' /etc/hosts.deny | wc -l`
echo "denyhosts.blocked $count"
