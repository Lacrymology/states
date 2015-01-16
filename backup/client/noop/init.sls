{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

#}
include:
  - backup.client.base
  - bash
  - local

{# manage a script which test archive integrity #}
/usr/local/bin/backup-store:
  file:
    - managed
    - source: salt://backup/client/validate.jinja2
    - mode: 755
    - template: jinja
    - require:
      - file: /usr/local
      - file: bash
