{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
include:
  - apt
  - hostname

sudo:
  file:
    - managed
    - name: /etc/sudoers
    - source: salt://sudo/config.jinja2
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - require:
      - pkg: sudo
  pkg:
    - installed
    - require:
      - cmd: apt_sources
