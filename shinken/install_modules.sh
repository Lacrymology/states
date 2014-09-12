#!/bin/bash

modules=( "auth-cfg-password" "booster-nrpe" "graphite" "nsca" "pickle-retention-file-generic" "sqlitedb" "syslog-sink" "ui-graphite" "webui" )
for module in "${modules[@]}"
do
    /usr/local/shinken/bin/shinken install $module
done
