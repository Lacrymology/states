{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - apt
  - sysctl

radvd:
  pkg:
    - installed
    - require:
      - cmd: apt_sources
  file:
    - managed
    - name: /etc/radvd.conf
    - source: salt://radvd/config.jinja2
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - require:
      - pkg: radvd
  service:
    - running
    - require:
      {#- requires specific pillar key, look in radvd/doc/pillar.rst #}
      - file: sysctl
    - watch:
      - pkg: radvd
      - file: radvd
