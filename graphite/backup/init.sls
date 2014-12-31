{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>
-#}
include:
  - bash
  - cron
  - postgresql.server.backup

backup-graphite:
  file:
    - managed
    - name: /etc/cron.daily/backup-graphite
    - user: root
    - group: root
    - mode: 500
    - template: jinja
    - source: salt://graphite/backup/cron.jinja2
    - require:
      - pkg: cron
      - file: /usr/local/bin/backup-postgresql
      - file: bash
