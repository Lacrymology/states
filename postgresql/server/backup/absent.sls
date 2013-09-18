{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Hung Nguyen Viet hvnsweeting@gmail.com
 
 Remove Backup client for PostgreSQL
 -#}
/etc/cron.daily/backup-postgresql:
  file:
    - absent

/usr/local/bin/backup-postgresql:
  file:
    - absent

/usr/local/bin/backup-postgresql-all:
  file:
    - absent
