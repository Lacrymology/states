{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - apt

logrotate:
  pkg:
    - latest
    - require:
      - cmd: apt_sources
  file:
    - managed
    - name: /etc/logrotate.conf
    - source: salt://logrotate/config.jinja2
    - user: root
    - group: root
    - mode: 440
    - template: jinja
    - require:
      - pkg: logrotate
