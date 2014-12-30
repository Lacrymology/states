{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>
-#}
include:
  - apt

rssh:
  pkg:
    - installed
    - require:
      - cmd: apt_sources
  file:
    - managed
    - name: /etc/rssh.conf
    - source: salt://rssh/config.jinja2
    - template: jinja
    - mode: 444
    - user: root
    - group: root
    - require:
      - pkg: rssh
