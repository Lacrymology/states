{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Bruno Clermont patate@fastmail.cn
 
 virtualenv backup state
 -#}
include:
  - local

/usr/local/bin/backup-pip:
  file:
    - managed
    - user: root
    - group: root
    - mode: 500
    - template: jinja
    - source: salt://virtualenv/backup/config.jinja2
    - require:
      - file: /usr/local
