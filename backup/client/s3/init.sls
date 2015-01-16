{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
include:
  - bash
  - local
  - backup.client.base
  - python.dev
  - s3cmd
  - virtualenv

/usr/local/bin/backup-store:
  file:
    - managed
    - template: jinja
    - user: root
    - group: root
    - mode: 550
    - source: salt://backup/client/s3/backup-store.jinja2
    - require:
      - pkg: s3cmd
      - file: /usr/local
      - file: bash

s3lite:
  virtualenv:
    - manage
    - name: /usr/local/s3lite
    - system_site_packages: False
    - require:
      - module: virtualenv
      - file: /usr/local
  file:
    - managed
    - name: /usr/local/s3lite/salt-requirements.txt
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://backup/client/s3/s3lite/requirements.jinja2
    - require:
      - virtualenv: s3lite
  module:
    - wait
    - name: pip.install
    - upgrade: True
    - bin_env: /usr/local/s3lite/bin/pip
    - requirements: /usr/local/s3lite/salt-requirements.txt
    - watch:
      - file: s3lite
      - pkg: python-dev

/etc/s3lite.yml:
  file:
    - managed
    - template: jinja
    - mode: 400
    - user: root
    - group: root
    - source: salt://backup/client/s3/s3lite/config.jinja2

{#- anyuser/program should can run this script, it just needs to provide
the config file as default config file is only for root #}
/usr/local/s3lite/bin/s3lite:
  file:
    - managed
    - source: salt://backup/client/s3/s3lite/s3lite.py
    - user: root
    - group: root
    - mode: 551
    - require:
      - module: s3lite
      - file: /etc/s3lite.yml
