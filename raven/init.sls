{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - pip

raven:
  file:
    - managed
    - name: {{ opts['cachedir'] }}/pip/raven
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://raven/requirements.jinja2
    - require:
      - module: pip
  module:
    - wait
    - name: pip.install
    - upgrade: True
    - requirements: {{ opts['cachedir'] }}/pip/raven
    - watch:
      - file: raven
