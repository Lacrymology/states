{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}

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
    - source: salt://mariadb/server/backup/script.jinja2
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
    - source: salt://mariadb/server/backup/dump_all.jinja2
    - require:
      - file: /usr/local
      - file: /usr/local/bin/backup-store
      - file: bash
