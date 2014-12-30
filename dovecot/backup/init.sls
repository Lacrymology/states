{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Luan Vo Ngoc <luan@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>
-#}
include:
  - bash
  - cron
  - backup.client

backup-dovecot:
  file:
    - managed
    - name: /etc/cron.daily/backup-dovecot
    - user: root
    - group: root
    - mode: 500
    - template: jinja
    - source: salt://dovecot/backup/cron.jinja2
    - require:
      - pkg: cron
      - file: /usr/local/bin/backup-file
      - file: bash
