{#
 Remove Backup for Gitlab
 #}
/etc/cron.daily/backup-gitlab:
  file:
    - absent