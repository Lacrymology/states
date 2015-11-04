{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - openvpn.server.absent
  - openvpn.client.absent

openvpn:
  pkg:
    - purged
    - require:
      - sls: openvpn.server.absent
      - sls: openvpn.client.absent

/etc/openvpn:
  file:
    - absent
    - require:
      - pkg: openvpn
