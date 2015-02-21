{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - uwsgi
  - pip

uwsgitop:
  file:
    - managed
    - name: {{ opts['cachedir'] }}/pip/uwsgi.top
    - source: salt://uwsgi/top/requirements.jinja2
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - require:
      - module: pip
  module:
    - wait
    - name: pip.install
    - requirements: {{ opts['cachedir'] }}/pip/uwsgi.top
    - watch:
      - file: uwsgitop
