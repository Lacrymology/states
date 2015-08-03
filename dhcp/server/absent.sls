{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from "upstart/absent.sls" import upstart_absent with context -%}
{{ upstart_absent('isc-dhcp-server') }}
{{ upstart_absent('isc-dhcp-server6') }}

dhcp-server:
  pkg:
    - purged
    - name: isc-dhcp-server
    - require:
      - service: isc-dhcp-server
      - service: isc-dhcp-server6
  user:
    - absent
    - name: dhcpd
    - require:
      - pkg: dhcp-server

dhcp-server_acl:
  pkg:
    - purged
    - name: acl

/var/lib/dhcp:
  file:
    - absent
    - require:
      - pkg: dhcp-server

/etc/dhcp/dhcpd6.conf:
  file:
    - absent
    - require:
      - pkg: dhcp-server
