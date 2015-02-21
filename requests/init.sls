{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - pip

requests:
  file:
    - managed
    - name: {{ opts['cachedir'] }}/pip/requests
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://requests/requirements.jinja2
    - require:
      - module: pip
  module:
    - wait
    - name: pip.install
    - upgrade: True
    - requirements: {{ opts['cachedir'] }}/pip/requests
    - watch:
      - file: requests
