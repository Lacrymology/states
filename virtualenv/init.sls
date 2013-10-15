{#
 Install all dependencies to create Python's virtualenv.
 #}
include:
  - pip
  - git
  - mercurial

python-virtualenv:
  pkg:
    - purged

virtualenv:
  file:
    - managed
    - name: {{ opts['cachedir'] }}/salt-virtualenv-requirements.txt
    - source: salt://virtualenv/requirements.jinja2
    - template: jinja
    - user: root
    - group: root
    - mode: 440
  module:
    - wait
    - name: pip.install
    - requirements: {{ opts['cachedir'] }}/salt-virtualenv-requirements.txt
    - watch:
      - file: virtualenv
    - require:
      - module: pip
      - pkg: git
      - module: mercurial
