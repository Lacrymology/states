{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

dhcp-server:
  pkg:
    - purged
    - name: isc-dhcp-server
  user:
    - absent
    - name: dhcpd
    - require:
      - pkg: dhcp-server
