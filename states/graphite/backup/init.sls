{#
 Backup client for Graphite
 #}
/etc/cron.daily/backup-graphite:
  file:
    - managed
    - user: root
    - group: root
    - mode: 500
    - template: jinja
    - source: salt://graphite/backup/cron.jinja2
