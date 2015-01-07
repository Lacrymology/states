{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>
-#}
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
