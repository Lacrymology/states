{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - pip

sleekxmpp:
  file:
    - managed
    - name: {{ opts['cachedir'] }}/pip/sleekxmpp
    - source: salt://sleekxmpp/requirements.jinja2
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - require:
      - file: {{ opts['cachedir'] }}/pip
      - module: pip
  module:
    - wait
    - name: pip.install
    - requirements: {{ opts['cachedir'] }}/pip/sleekxmpp
    - watch:
      - file: sleekxmpp
    - reload_modules: True
