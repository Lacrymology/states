{#-
 Author: Hung Nguyen Viet hvnsweeting@gmail.com
 Maintainer: Hung Nguyen Viet hvnsweeting@gmail.com
 
 Install a DNS cache server
 -#}
include:
  - apt

pdnsd:
  pkg:
    - installed
    - require:
      - cmd: apt_sources
      - debconf: pdnsd
  debconf:
    - set
    - data:
        'pdnsd/conf': {'type': 'select', 'value': 'Manual'}
    - require:
      - pkg: apt_sources
  service:
    - running
    - enable: True
    - order: 50
    - watch:
      - file: /etc/default/pdnsd
      - file: /etc/pdnsd.conf
      - pkg: pdnsd

/etc/default/pdnsd:
  file:
    - managed
    - require:
      - pkg: pdnsd
    - template: jinja
    - source: salt://pdnsd/init.jinja2
    - user: root
    - group: root
    - mode: 440

/etc/pdnsd.conf:
  file:
    - managed
    - require:
      - pkg: pdnsd
    - template: jinja
    - source: salt://pdnsd/config.jinja2
    - user: root
    - group: root
    - mode: 440
