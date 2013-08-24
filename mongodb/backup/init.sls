{#
 Backup client for MongoDB
 #}

/usr/local/bin/backup-mongodb:
  file:
    - managed
    - user: root
    - group: root
    - mode: 500
    - template: jinja
    - source: salt://mongodb/server/backup/script.jinja2

/usr/local/bin/backup-mongodb-all:
  file:
    - managed
    - user: root
    - group: root
    - mode: 500
    - template: jinja
    - source: salt://mongodb/server/backup/dump_all.jinja2
