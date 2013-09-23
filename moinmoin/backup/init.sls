{#
 Backup client for moinmoin
 #}
include:
  - cron

/etc/cron.daily/backup-moinmoin:
  file:
    - managed
    - user: root
    - group: root
    - mode: 500
    - template: jinja
    - source: salt://moinmoin/backup/cron.jinja2
    - require:
      - pkg: cron
