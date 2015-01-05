{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Viet Hung Nguyen <hvn@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>
-#}
include:
  - bash
  - cron
  - postgresql.server.backup
  - backup.client

backup-djangopypi2:
  file:
    - managed
    - name: /etc/cron.daily/backup-djangopypi2
    - user: root
    - group: root
    - mode: 500
    - template: jinja
    - source: salt://djangopypi2/backup/cron.jinja2
    - require:
      - pkg: cron
      - file: /usr/local/bin/backup-postgresql
      - file: /usr/local/bin/backup-file
      - file: bash
