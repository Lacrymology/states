{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - bash
  - backup.client
  - cron
  - pip

backup-elasticsearch:
  file:
    - managed
    - name: /etc/cron.daily/backup-elasticsearch
    - user: root
    - group: root
    - mode: 500
    - template: jinja
    - source: salt://elasticsearch/backup/cron.jinja2
    - require:
      - pkg: cron
      - file: /usr/local/bin/backup-store
      - file: bash
      - module: esclient

esclient:
  file:
    - managed
    - name: {{ opts['cachedir'] }}/pip/elasticsearch.backup
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://elasticsearch/backup/requirements.jinja2
    - require:
      - module: pip
  module:
    - wait
    - name: pip.install
    - upgrade: True
    - requirements: {{ opts['cachedir'] }}/pip/elasticsearch.backup
    - watch:
      - file: esclient
