{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Hung Nguyen Viet hvnsweeting@gmail.com
 
 Backup client for PostgreSQL
 -#}
include:
  - local

/etc/cron.daily/backup-postgresql:
  file:
    - absent

/usr/local/bin/backup-postgresql:
  file:
    - managed
    - user: root
    - group: root
    - mode: 500
    - template: jinja
    - source: salt://postgresql/server/backup/script.jinja2

/usr/local/bin/backup-postgresql-all:
  file:
    - managed
    - user: root
    - group: root
    - mode: 500
    - template: jinja
    - source: salt://postgresql/server/backup/dump_all.jinja2
    - require:
      - file: /usr/local
