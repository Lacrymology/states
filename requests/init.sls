{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>

Install Requests (HTTP library) into OS/root site-packages.
-#}
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
    - reload_modules: True
