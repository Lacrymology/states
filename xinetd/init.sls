{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

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
