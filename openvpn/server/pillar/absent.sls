{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

openvpn_pillar:
  cmd:
    - run
    - name: rm -f {{ grains['saltpath'] }}/pillar/openvpn.py*

/etc/salt/master.d/openvpn.conf:
  file:
    - absent
