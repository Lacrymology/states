{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - bash
  - local
  - salt.minion.deps

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
      {#- for unzip #}
      - pkg: salt_minion_deps
