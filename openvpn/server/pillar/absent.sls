{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- set server_type = 'minion' if salt['pillar.get']('__test__', False) else 'master' %}

openvpn_pillar:
  cmd:
    - run
    - name: rm -f {{ grains['saltpath'] }}/pillar/openvpn.py*

/etc/salt/{{ server_type }}.d/ext_pillar.conf:
  file:
    - absent
