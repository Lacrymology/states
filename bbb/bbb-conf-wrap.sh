#!/bin/sh

LOG=/tmp/bbb_conf.log
echo "Start $0" >> $LOG
date >> $LOG
echo "Arguments: $*" >> $LOG
echo "Running processes:" >> $LOG
ps awwx >> $LOG
echo "Environment:" >> $LOG
set >> $LOG
echo "Run:" >> $LOG
(/usr/local/bin/bbb-conf $* 2>&1) >> $LOG
echo "End of run" >> $LOG
