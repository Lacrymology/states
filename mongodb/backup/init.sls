{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Van Pham Diep <favadi@robotinfra.com>
-#}

include:
  - bash
  - local
  - backup.client

/usr/local/bin/backup-mongodb:
  file:
    - managed
    - user: root
    - group: root
    - mode: 500
    - template: jinja
    - source: salt://mongodb/backup/script.jinja2
    - require:
      - file: /usr/local
      - file: /usr/local/bin/backup-store
      - file: bash

/usr/local/bin/backup-mongodb-all:
  file:
    - managed
    - user: root
    - group: root
    - mode: 500
    - template: jinja
    - source: salt://mongodb/backup/dump_all.jinja2
    - require:
      - file: /usr/local
      - file: /usr/local/bin/backup-store
      - file: bash
