{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

openswan:
  service:
    - dead
    - enable: False
  pkg:
    - purged
    - require:
      - service: openswan
  file:
    - absent
    - names:
      - /etc/ipsec.conf
      - /etc/ipsec.d
      - /etc/ipsec.secrets
    - require:
      - pkg: openswan
