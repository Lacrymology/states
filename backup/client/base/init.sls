{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Luan Vo Ngoc <luan@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>
-#}
include:
  - bash
  - local

/usr/local/bin/backup-file:
  file:
    - managed
    - user: root
    - group: root
    - mode: 500
    - template: jinja
    - source: salt://backup/file.jinja2
    - require:
      - file: /usr/local
      - file: bash

/usr/local/bin/backup-validate:
  file:
    - managed
    - user: root
    - group: root
    - mode: 500
    - template: jinja
    - source: salt://backup/client/validate.jinja2
    - require:
      - file: /usr/local
      - file: bash
