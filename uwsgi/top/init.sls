{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Van Pham Diep <favadi@robotinfra.com>
-#}
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
