{#
 Backup client for Discourse
 #}
include:
  - cron

/etc/cron.daily/backup-discourse:
  file:
    - managed
    - user: root
    - group: root
    - mode: 500
    - template: jinja
    - source: salt://discourse/backup/cron.jinja2
    - require:
      - pkg: cron
