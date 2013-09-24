{#
 Backup client for Mariadb
 #}
include:
  - local

/etc/cron.daily/backup-mysql:
  file:
    - absent

/usr/local/bin/backup-mysql:
  file:
    - managed
    - user: root
    - group: root
    - mode: 500
    - template: jinja
    - source: salt://mysql/server/backup/script.jinja2

/usr/local/bin/backup-mysql-all:
  file:
    - managed
    - user: root
    - group: root
    - mode: 500
    - template: jinja
    - source: salt://mysql/server/backup/dump_all.jinja2
    - require:
      - file: /usr/local
