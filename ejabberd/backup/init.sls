include:
  - cron
  - postgresql.server.backup

/etc/cron.daily/backup-ejabberd:
  file:
    - managed
    - user: root
    - group: root
    - mode: 500
    - template: jinja
    - source: salt://ejabberd/backup/cron.jinja2
    - require:
      - pkg: cron
      - file: /usr/local/bin/backup-postgresql