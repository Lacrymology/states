{#- Usage of this is governed by a license that can be found in doc/license.rst -#}
include:
  - diamond

dhcp-server_diamond_resources:
  file:
    - accumulated
    - name: processes
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - text:
      - |
        [[dhcp-server]]
        name = dhcpd
