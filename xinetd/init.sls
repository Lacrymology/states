{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Van Diep Pham <favadi@robotinfra.com>
Maintainer: Van Diep Pham <favadi@robotinfra.com>
-#}

include:
  - apt

xinetd:
  pkg:
    - installed
    - require:
      - cmd: apt_sources
  file:
    - managed
    - name: /etc/xinetd.conf
    - source: salt://xinetd/config.jinja2
    - template: jinja
    - mode: 440
    - user: root
    - group: root
    - require:
      - pkg: xinetd
      - file: /etc/xinetd.d
  service:
    - running
    - watch:
      - file: xinetd

/etc/xinetd.d:
  file:
    - directory
    - user: root
    - groupt: root
    - mode: 750
    - require:
      - pkg: xinetd
