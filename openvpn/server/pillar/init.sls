{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - salt.master
  - openvpn.server

openvpn_pillar:
  file:
    - managed
    - name: {{ grains['saltpath'] }}/pillar/openvpn.py
    - source: salt://openvpn/server/pillar/ext_pillar.py
    - user: root
    - group: root
    - mode: 444
    - require:
      - sls: openvpn.server
    - watch_in:
      - service: salt-master

/etc/salt/master.d/openvpn.conf:
  file:
    - managed
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://openvpn/server/pillar/config.jinja2
    - require:
      - file: openvpn_pillar
    - watch_in:
      - service: salt-master
