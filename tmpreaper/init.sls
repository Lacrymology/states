{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>
-#}
include:
  - apt
  - cron

tmpreaper:
  pkg:
    - latest
    - require:
      - cmd: apt_sources
  file:
    - managed
    - name: /etc/tmpreaper.conf
    - source: salt://tmpreaper/config.jinja2
    - template: jinja
    - mode: 444
    - user: root
    - group: root
    - require:
      - pkg: tmpreaper
      - pkg: cron
