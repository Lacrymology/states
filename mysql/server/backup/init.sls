{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - bash
  - local
  - backup.client

/usr/local/bin/backup-mysql:
  file:
    - managed
    - user: root
    - group: root
    - mode: 500
    - template: jinja
    - source: salt://mysql/server/backup/script.jinja2
    - require:
      - file: /usr/local
      - file: /usr/local/bin/backup-store
      - file: bash

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
      - file: /usr/local/bin/backup-store
      - file: bash
