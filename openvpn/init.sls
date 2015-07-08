{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - apt

openvpn:
  pkg:
    - installed
    - require:
      - cmd: apt_sources
  module:
    - wait
    - name: service.stop
    - m_name: openvpn
    - watch:
      - pkg: openvpn
  cmd:
    - wait
    - name: update-rc.d -f openvpn remove
    - watch:
      - module: openvpn
  file:
    - absent
    - name: /etc/init.d/openvpn
    - watch:
      - cmd: openvpn
