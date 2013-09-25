{#-
 Remove Backup for Wordpress
#}
/etc/cron.daily/backup-wordpress:
  file:
    - absent
