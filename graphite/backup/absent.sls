{#
 Turn off backup client for Graphite
 #}
/etc/cron.daily/backup-graphite:
  file:
    - absent
