{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Bruno Clermont patate@fastmail.cn
 
 Install TMPReaper that cleanup /tmp for left over files.
 -#}
include:
  - cron
  - apt

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
