{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
include:
  - apt

screen:
  pkg:
    - latest
    - require:
      - cmd: apt_sources
  file:
    - managed
    - name: /etc/screenrc
    - template: jinja
    - user: root
    - group: root
    - mode: 444
    - source: salt://screen/config.jinja2
    - require:
      - pkg: screen
