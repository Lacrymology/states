{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Bruno Clermont patate@fastmail.cn
 
 Undo sentry.backup state
 -#}
/etc/cron.daily/backup-sentry:
  file:
    - absent
