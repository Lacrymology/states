{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - pip
  - python.dev

mercurial:
  pkg:
    - purged
    - name: mercurial-common
  file:
    - managed
    - name: {{ opts['cachedir'] }}/pip/mercurial
    - source: salt://mercurial/requirements.jinja2
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - require:
      - module: pip
  module:
    - wait
    - name: pip.install
    - requirements: {{ opts['cachedir'] }}/pip/mercurial
    - watch:
      - file: mercurial
    - require:
      - pkg: python-dev
