{#
 Undo djangopypi2.backup state
 #}
/etc/cron.daily/backup-djangopypi2:
  file:
    - absent
