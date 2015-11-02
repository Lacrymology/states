{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - apt
  - sysctl

radvd:
  pkg:
    - installed
    - require:
      - cmd: apt_sources
  group:
    - present
    - addusers:
      - radvd
    - require:
      - pkg: radvd
  file:
    - managed
    - name: /etc/radvd.conf
    - source: salt://radvd/config.jinja2
    - template: jinja
    - user: root
    - group: radvd
    - mode: 440
    - require:
      - group: radvd
  service:
    - running
    - require:
      {#- requires specific pillar key, look in radvd/doc/pillar.rst #}
      - file: sysctl
    - watch:
      - pkg: radvd
      - file: radvd
