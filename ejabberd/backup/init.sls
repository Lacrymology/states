{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - cron
  - postgresql.server.backup
  - bash

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
      - file: bash
