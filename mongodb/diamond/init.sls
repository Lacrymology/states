{#
 Diamond statistics for MongoDB
#}
include:
  - diamond
  - pip

diamond-pymongo:
  file:
    - managed
    - name: /usr/local/diamond/salt-pymongo-requirements.txt
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
    - pkgs: ''
    - bin_env: /usr/local/diamond
    - requirements: /usr/local/diamond/salt-pymongo-requirements.txt
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
      - watch:
        - file: diamond_mongodb
