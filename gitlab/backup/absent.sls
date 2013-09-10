{#
 Remove Backup for Gitlab
 #}
/etc/cron.daily/backup-discourse:
  file:
    - absent