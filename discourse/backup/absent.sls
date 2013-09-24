{#-
  Remove backup Discourse
#}
/etc/cron.daily/backup-discourse:
  file:
    - absent