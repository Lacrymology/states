{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>
-#}
include:
  - bash
  - local
  - backup.client

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
    - require:
      - file: /usr/local
      - file: /usr/local/bin/backup-store
      - file: bash

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
      - file: /usr/local/bin/backup-store
      - file: bash

/usr/local/bin/backup-postgresql-by-role:
  file:
    - managed
    - user: root
    - group: root
    - mode: 500
    - template: jinja
    - source: salt://postgresql/server/backup/backup_by_role.jinja2
    - require:
      - file: /usr/local/bin/backup-postgresql
      - file: bash
