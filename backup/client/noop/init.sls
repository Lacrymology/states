{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

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
