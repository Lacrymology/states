{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
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
