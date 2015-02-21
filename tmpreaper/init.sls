{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

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
