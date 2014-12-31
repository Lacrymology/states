{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Viet Hung Nguyen <hvn@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>

Mange pysc pip package, which provide lib support for python scrips in salt common
#}

include:
  - local
  - pip
  - python.dev

{{ opts['cachedir'] }}/salt-pysc-requirements.txt:
  file:
    - absent

pysc:
  file:
    - managed
    - name: {{ opts['cachedir'] }}/pip/pysc
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://pysc/requirements.jinja2
  module:
    - wait
    - name: pip.install
    - upgrade: True
    - requirements: {{ opts['cachedir'] }}/pip/pysc
    - require:
      - module: pip
      - file: python
    - watch:
      - file: pysc
      - pkg: python-dev

pysc_log_test:
  file:
    - managed
    - name: /usr/local/bin/log_test.py
    - source: salt://pysc/log_test.py
    - user: root
    - group: root
    - mode: 550
    - require:
      - module: pysc
      - file: /usr/local
