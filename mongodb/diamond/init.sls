{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
include:
  - diamond
  - mongodb
  - pip

diamond-pymongo:
  file:
    - managed
    - name: /usr/local/diamond/salt-mongodb-requirements.txt
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://mongodb/diamond/requirements.jinja2
    - require:
      - virtualenv: diamond
  module:
    - wait
    - name: pip.install
    - upgrade: True
    - bin_env: /usr/local/diamond
    - requirements: /usr/local/diamond/salt-mongodb-requirements.txt
    - require:
      - virtualenv: diamond
    - watch:
      - file: diamond-pymongo

diamond_mongodb:
  file:
    - managed
    - template: jinja
    - name: /etc/diamond/collectors/MongoDBCollector.conf
    - user: root
    - group: root
    - mode: 440
    - source: salt://mongodb/diamond/config.jinja2
    - require:
      - module: diamond-pymongo
      - file: /etc/diamond/collectors
    - watch_in:
      - service: diamond

mongodb_diamond_resources:
  file:
    - accumulated
    - name: processes
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - text:
      - |
        [[mongodb]]
        exe = ^\/usr\/bin\/mongod$

extend:
  diamond:
    service:
      - require:
        - service: mongodb
