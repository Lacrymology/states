{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Hung Nguyen Viet hvnsweeting@gmail.com
 
 Turn off backup client for Graphite
 -#}
/etc/cron.daily/backup-graphite:
  file:
    - absent
