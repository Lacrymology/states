{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

openswan:
  service:
    - dead
    - enable: False
  file:
    - absent
    - names:
      - /etc/ipsec.conf
      - /etc/ipsec.d
      - /etc/ipsec.secrets
    - pkg: openswan
  pkg:
    - purged
    - require:
      - service: openswan
