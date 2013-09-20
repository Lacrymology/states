{#
 Backup client for djangopypi2
 #}
include:
  - cron

/etc/cron.daily/backup-djangopypi2:
  file:
    - managed
    - user: root
    - group: root
    - mode: 500
    - template: jinja
    - source: salt://djangopypi2/backup/cron.jinja2
    - require:
      - pkg: cron
