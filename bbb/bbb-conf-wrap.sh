#!/bin/sh

log(){
    while read data; do
        echo $data | logger -t "bbb" -p debug
    done
}

echo "Start $0" | log
date | log
echo "Arguments: $*" | log
echo "Running processes:" | log
ps awwx | log
echo "Environment:" | log
set | log
echo "Run:" | log
/usr/local/bin/bbb-conf $* 2>&1
echo "End of run" | log
