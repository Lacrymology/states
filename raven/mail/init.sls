{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Bruno Clermont patate@fastmail.cn
 -#}
include:
  - raven
  - rsyslog

/usr/bin/mail:
  file:
    - managed
    - template: jinja
    - user: root
    - group: root
    - mode: 775
    - source: salt://raven/mail/script.jinja2
    - require:
      - module: raven
      - service: rsyslog
