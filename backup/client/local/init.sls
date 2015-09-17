{#- Usage of this is governed by a license that can be found in doc/license.rst -#}
include:
  - bash
  - local
  - backup.client.base

/usr/local/bin/backup-store:
  file:
    - managed
    - template: jinja
    - user: root
    - group: root
    - mode: 550
    - source: salt://backup/client/local/backup-store.jinja2
    - context:
        path: {{ salt["pillar.get"]("backup:local:path") }}
        subdir: {{ salt["pillar.get"]("backup:local:subdir", False)|default(grains["id"], boolean=True) }}
    - require:
      - file: /usr/local
      - file: bash
