{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

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
