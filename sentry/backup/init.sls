{#
 Backup client for Sentry
 #}
include:
  - cron

/etc/cron.daily/backup-sentry:
  file:
    - managed
    - user: root
    - group: root
    - mode: 500
    - template: jinja
    - source: salt://sentry/backup/cron.jinja2
    - require:
      - pkg: cron
