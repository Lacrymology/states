include:
  - pip

raven:
  file:
    - managed
    - name: {{ opts['cachedir'] }}/raven-requirements.txt
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://raven/requirements.jinja2
  module:
    - wait
    - name: pip.install
    - pkgs: ''
    - upgrade: True
    - requirements: {{ opts['cachedir'] }}/raven-requirements.txt
    - require:
      - pkg: python-pip
    - watch:
      - file: raven
