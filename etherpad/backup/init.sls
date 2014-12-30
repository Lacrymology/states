{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Dang Tung Lam <lam@robotinfra.com>
Maintainer: Van Pham Diep <favadi@robotinfra.com>
-#}
include:
  - bash
  - cron
  - postgresql.server.backup

backup-etherpad:
  file:
    - managed
    - name: /etc/cron.daily/backup-etherpad
    - user: root
    - group: root
    - mode: 500
    - template: jinja
    - source: salt://etherpad/backup/cron.jinja2
    - require:
      - pkg: cron
      - file: /usr/local/bin/backup-postgresql
      - file: bash
